class APIEntreprise::API
  ENTREPRISE_RESOURCE_NAME = "v3/insee/sirene/unites_legales/%{id}"
  ETABLISSEMENT_RESOURCE_NAME = "v2/etablissements/%{id}"
  EXTRAIT_KBIS_NAME = "v3/infogreffe/rcs/unites_legales/%{id}/extrait_kbis"
  TVA_NAME = "v3/european_commission/unites_legales/%{id}/numero_tva"
  EXERCICES_RESOURCE_NAME = "v2/exercices/%{id}"
  RNA_RESOURCE_NAME = "v2/associations/%{id}"
  EFFECTIFS_RESOURCE_NAME = "v2/effectifs_mensuels_acoss_covid"
  EFFECTIFS_ANNUELS_RESOURCE_NAME = "v2/effectifs_annuels_acoss_covid/%{id}"
  ATTESTATION_SOCIALE_RESOURCE_NAME = "v4/urssaf/unites_legales/%{id}/attestation_vigilance"
  ATTESTATION_FISCALE_RESOURCE_NAME = "v4/dgfip/unites_legales/%{id}/attestation_fiscale"
  BILANS_BDF_RESOURCE_NAME = "v2/bilans_entreprises_bdf/%{id}"
  PRIVILEGES_RESOURCE_NAME = "v2/privileges"

  TIMEOUT = 20
  DEFAULT_API_ENTREPRISE_DELAY = 0.0

  attr_reader :procedure
  attr_accessor :token
  attr_accessor :api_object

  def initialize(procedure_id = nil)
    return if procedure_id.blank?

    @procedure = Procedure.find(procedure_id)
    @token = @procedure.api_entreprise_token
  end

  def entreprise(siren)
    call_with_siret(ENTREPRISE_RESOURCE_NAME, siren)
  end

  def etablissement(siret)
    call_with_siret(ETABLISSEMENT_RESOURCE_NAME, siret)
  end

  def extrait_kbis(siren)
    call_with_siret(EXTRAIT_KBIS_NAME, siren)
  end

  def tva(siren)
    call_with_siret(TVA_NAME, siren)
  end

  def exercices(siret)
    call_with_siret(EXERCICES_RESOURCE_NAME, siret)
  end

  def rna(siret)
    call_with_siret(RNA_RESOURCE_NAME, siret)
  end

  def effectifs(siren, annee, mois)
    endpoint = [EFFECTIFS_RESOURCE_NAME, annee, mois, "entreprise", "%{id}"].join('/')
    call_with_siret(endpoint, siren)
  end

  def effectifs_annuels(siren)
    call_with_siret(EFFECTIFS_ANNUELS_RESOURCE_NAME, siren)
  end

  def attestation_sociale(siren)
    return unless procedure.api_entreprise_role?("attestations_sociales")

    call_with_siret(ATTESTATION_SOCIALE_RESOURCE_NAME, siren)
  end

  def attestation_fiscale(siren, user_id)
    return unless procedure.api_entreprise_role?("attestations_fiscales")

    call_with_siret(ATTESTATION_FISCALE_RESOURCE_NAME, siren, user_id: user_id)
  end

  def bilans_bdf(siren)
    return unless procedure.api_entreprise_role?("bilans_entreprise_bdf")

    call_with_siret(BILANS_BDF_RESOURCE_NAME, siren)
  end

  def privileges
    url = make_url(PRIVILEGES_RESOURCE_NAME)
    call(url)
  end

  def current_status
    status_url = "https://status.entreprise.api.gouv.fr/summary.json"
    response = Typhoeus.get(status_url, timeout: 1)

    handle_response(response)
  end

  private

  def call_with_siret(resource_name, siret_or_siren, user_id: nil)
    url = make_url(resource_name, siret_or_siren)

    params = build_params(user_id)

    call(url, params)
  end

  def call(url, params = nil)
    verify_token!

    # this is a poor man throttling
    # the idea is to queue api entreprise job on 1 worker
    # and add a delay between each call
    # example: API_ENTREPRISE_DELAY=1 => 60 rpm max
    if api_entreprise_delay != 0.0
      sleep api_entreprise_delay
    end

    response = Typhoeus.get(url,
      headers: { Authorization: "Bearer #{token}" },
      params: params,
      timeout: TIMEOUT)

    handle_response(response)
  end

  def handle_response(response)
    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    elsif response.code&.between?(401, 499)
      raise Error::ResourceNotFound.new(response)
    elsif response.code == 400
      raise Error::BadFormatRequest.new(response)
    elsif response.code == 502
      raise	Error::BadGateway.new(response)
    elsif response.code == 503
      raise Error::ServiceUnavailable.new(response)
    elsif response.timed_out?
      raise Error::TimedOut.new(response)
    else
      raise Error::RequestFailed.new(response)
    end
  end

  def make_url(resource_name, siret_or_siren = nil)
    [API_ENTREPRISE_URL, format(resource_name, id: siret_or_siren)].compact.join("/")
  end

  def build_params(user_id)
    params = base_params

    params[:object] = if api_object.present?
      api_object
    elsif procedure.present?
      "procedure_id: #{procedure.id}"
    end

    params[:user_id] = user_id if user_id.present?

    params
  end

  def base_params
    # rubocop:disable DS/ApplicationName
    {
      context: "demarches-simplifiees.fr",
      recipient: ENV.fetch('API_ENTREPRISE_DEFAULT_SIRET'),
      non_diffusables: true
    }
    # rubocop:enable DS/ApplicationName
  end

  def api_entreprise_delay
    ENV.fetch("API_ENTREPRISE_DELAY", DEFAULT_API_ENTREPRISE_DELAY).to_f
  end

  def verify_token!
    return unless APIEntrepriseToken.new(token).expired?

    raise APIEntrepriseToken::TokenError, I18n.t("api_entreprise.errors.token_expired")
  end
end
