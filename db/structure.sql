SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: abuse_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.abuse_reports (
    id integer NOT NULL,
    reporter_id integer,
    user_id integer,
    message text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    message_html text,
    cached_markdown_version integer
);


--
-- Name: abuse_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.abuse_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: abuse_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.abuse_reports_id_seq OWNED BY public.abuse_reports.id;


--
-- Name: appearances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appearances (
    id integer NOT NULL,
    title character varying NOT NULL,
    description text NOT NULL,
    header_logo character varying,
    logo character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    description_html text,
    cached_markdown_version integer,
    new_project_guidelines text,
    new_project_guidelines_html text,
    header_message text,
    header_message_html text,
    footer_message text,
    footer_message_html text,
    message_background_color text,
    message_font_color text,
    favicon character varying,
    email_header_and_footer_enabled boolean DEFAULT false NOT NULL,
    updated_by integer
);


--
-- Name: appearances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appearances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appearances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appearances_id_seq OWNED BY public.appearances.id;


--
-- Name: application_setting_terms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_setting_terms (
    id integer NOT NULL,
    cached_markdown_version integer,
    terms text NOT NULL,
    terms_html text
);


--
-- Name: application_setting_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.application_setting_terms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_setting_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.application_setting_terms_id_seq OWNED BY public.application_setting_terms.id;


--
-- Name: application_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_settings (
    id integer NOT NULL,
    default_projects_limit integer,
    signup_enabled boolean,
    gravatar_enabled boolean,
    sign_in_text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    home_page_url character varying,
    default_branch_protection integer DEFAULT 2,
    restricted_visibility_levels text,
    version_check_enabled boolean DEFAULT true,
    max_attachment_size integer DEFAULT 10 NOT NULL,
    default_project_visibility integer,
    default_snippet_visibility integer,
    domain_whitelist text,
    user_oauth_applications boolean DEFAULT true,
    after_sign_out_path character varying,
    session_expire_delay integer DEFAULT 10080 NOT NULL,
    import_sources text,
    help_page_text text,
    admin_notification_email character varying,
    shared_runners_enabled boolean DEFAULT true NOT NULL,
    max_artifacts_size integer DEFAULT 100 NOT NULL,
    runners_registration_token character varying,
    max_pages_size integer DEFAULT 100 NOT NULL,
    require_two_factor_authentication boolean DEFAULT false,
    two_factor_grace_period integer DEFAULT 48,
    metrics_enabled boolean DEFAULT false,
    metrics_host character varying DEFAULT 'localhost'::character varying,
    metrics_pool_size integer DEFAULT 16,
    metrics_timeout integer DEFAULT 10,
    metrics_method_call_threshold integer DEFAULT 10,
    recaptcha_enabled boolean DEFAULT false,
    recaptcha_site_key character varying,
    recaptcha_private_key character varying,
    metrics_port integer DEFAULT 8089,
    akismet_enabled boolean DEFAULT false,
    akismet_api_key character varying,
    metrics_sample_interval integer DEFAULT 15,
    email_author_in_body boolean DEFAULT false,
    default_group_visibility integer,
    repository_checks_enabled boolean DEFAULT false,
    shared_runners_text text,
    metrics_packet_size integer DEFAULT 1,
    disabled_oauth_sign_in_sources text,
    health_check_access_token character varying,
    send_user_confirmation_email boolean DEFAULT false,
    container_registry_token_expire_delay integer DEFAULT 5,
    after_sign_up_text text,
    user_default_external boolean DEFAULT false NOT NULL,
    repository_storages character varying DEFAULT 'default'::character varying,
    enabled_git_access_protocol character varying,
    domain_blacklist_enabled boolean DEFAULT false,
    domain_blacklist text,
    usage_ping_enabled boolean DEFAULT true NOT NULL,
    sign_in_text_html text,
    help_page_text_html text,
    shared_runners_text_html text,
    after_sign_up_text_html text,
    rsa_key_restriction integer DEFAULT 0 NOT NULL,
    dsa_key_restriction integer DEFAULT '-1'::integer NOT NULL,
    ecdsa_key_restriction integer DEFAULT 0 NOT NULL,
    ed25519_key_restriction integer DEFAULT 0 NOT NULL,
    housekeeping_enabled boolean DEFAULT true NOT NULL,
    housekeeping_bitmaps_enabled boolean DEFAULT true NOT NULL,
    housekeeping_incremental_repack_period integer DEFAULT 10 NOT NULL,
    housekeeping_full_repack_period integer DEFAULT 50 NOT NULL,
    housekeeping_gc_period integer DEFAULT 200 NOT NULL,
    html_emails_enabled boolean DEFAULT true,
    plantuml_url character varying,
    plantuml_enabled boolean,
    terminal_max_session_time integer DEFAULT 0 NOT NULL,
    unique_ips_limit_per_user integer,
    unique_ips_limit_time_window integer,
    unique_ips_limit_enabled boolean DEFAULT false NOT NULL,
    default_artifacts_expire_in character varying DEFAULT '0'::character varying NOT NULL,
    uuid character varying,
    polling_interval_multiplier numeric DEFAULT 1.0 NOT NULL,
    cached_markdown_version integer,
    prometheus_metrics_enabled boolean DEFAULT true NOT NULL,
    help_page_hide_commercial_content boolean DEFAULT false,
    help_page_support_url character varying,
    performance_bar_allowed_group_id integer,
    hashed_storage_enabled boolean DEFAULT true NOT NULL,
    project_export_enabled boolean DEFAULT true NOT NULL,
    auto_devops_enabled boolean DEFAULT true NOT NULL,
    throttle_unauthenticated_enabled boolean DEFAULT false NOT NULL,
    throttle_unauthenticated_requests_per_period integer DEFAULT 3600 NOT NULL,
    throttle_unauthenticated_period_in_seconds integer DEFAULT 3600 NOT NULL,
    throttle_authenticated_api_enabled boolean DEFAULT false NOT NULL,
    throttle_authenticated_api_requests_per_period integer DEFAULT 7200 NOT NULL,
    throttle_authenticated_api_period_in_seconds integer DEFAULT 3600 NOT NULL,
    throttle_authenticated_web_enabled boolean DEFAULT false NOT NULL,
    throttle_authenticated_web_requests_per_period integer DEFAULT 7200 NOT NULL,
    throttle_authenticated_web_period_in_seconds integer DEFAULT 3600 NOT NULL,
    password_authentication_enabled_for_web boolean,
    password_authentication_enabled_for_git boolean DEFAULT true NOT NULL,
    gitaly_timeout_default integer DEFAULT 55 NOT NULL,
    gitaly_timeout_medium integer DEFAULT 30 NOT NULL,
    gitaly_timeout_fast integer DEFAULT 10 NOT NULL,
    authorized_keys_enabled boolean DEFAULT true NOT NULL,
    auto_devops_domain character varying,
    pages_domain_verification_enabled boolean DEFAULT true NOT NULL,
    user_default_internal_regex character varying,
    allow_local_requests_from_hooks_and_services boolean DEFAULT false NOT NULL,
    enforce_terms boolean DEFAULT false,
    mirror_available boolean DEFAULT true NOT NULL,
    hide_third_party_offers boolean DEFAULT false NOT NULL,
    instance_statistics_visibility_private boolean DEFAULT false NOT NULL,
    web_ide_clientside_preview_enabled boolean DEFAULT false NOT NULL,
    user_show_add_ssh_key_message boolean DEFAULT true NOT NULL,
    usage_stats_set_by_user_id integer,
    receive_max_input_size integer,
    diff_max_patch_bytes integer DEFAULT 102400 NOT NULL,
    archive_builds_in_seconds integer,
    commit_email_hostname character varying,
    protected_ci_variables boolean DEFAULT false NOT NULL,
    runners_registration_token_encrypted character varying,
    local_markdown_version integer DEFAULT 0 NOT NULL,
    first_day_of_week integer DEFAULT 0 NOT NULL,
    default_project_creation integer DEFAULT 2 NOT NULL,
    external_authorization_service_enabled boolean DEFAULT false NOT NULL,
    external_authorization_service_url character varying,
    external_authorization_service_default_label character varying,
    external_authorization_service_timeout double precision DEFAULT 0.5,
    external_auth_client_cert text,
    encrypted_external_auth_client_key text,
    encrypted_external_auth_client_key_iv character varying,
    encrypted_external_auth_client_key_pass character varying,
    encrypted_external_auth_client_key_pass_iv character varying,
    lets_encrypt_notification_email character varying,
    lets_encrypt_terms_of_service_accepted boolean DEFAULT false NOT NULL,
    elasticsearch_shards integer DEFAULT 5 NOT NULL,
    elasticsearch_replicas integer DEFAULT 1 NOT NULL,
    encrypted_lets_encrypt_private_key text,
    encrypted_lets_encrypt_private_key_iv text,
    required_instance_ci_template character varying,
    dns_rebinding_protection_enabled boolean DEFAULT true NOT NULL,
    default_project_deletion_protection boolean DEFAULT false NOT NULL,
    grafana_enabled boolean DEFAULT false NOT NULL,
    lock_memberships_to_ldap boolean DEFAULT false NOT NULL,
    help_text text,
    elasticsearch_indexing boolean DEFAULT false NOT NULL,
    elasticsearch_search boolean DEFAULT false NOT NULL,
    shared_runners_minutes integer DEFAULT 0 NOT NULL,
    repository_size_limit bigint DEFAULT 0,
    elasticsearch_url character varying DEFAULT 'http://localhost:9200'::character varying,
    elasticsearch_aws boolean DEFAULT false NOT NULL,
    elasticsearch_aws_region character varying DEFAULT 'us-east-1'::character varying,
    elasticsearch_aws_access_key character varying,
    elasticsearch_aws_secret_access_key character varying,
    geo_status_timeout integer DEFAULT 10,
    elasticsearch_experimental_indexer boolean,
    check_namespace_plan boolean DEFAULT false NOT NULL,
    mirror_max_delay integer DEFAULT 300 NOT NULL,
    mirror_max_capacity integer DEFAULT 100 NOT NULL,
    mirror_capacity_threshold integer DEFAULT 50 NOT NULL,
    slack_app_enabled boolean DEFAULT false,
    slack_app_id character varying,
    slack_app_secret character varying,
    slack_app_verification_token character varying,
    allow_group_owners_to_manage_ldap boolean DEFAULT true NOT NULL,
    email_additional_text character varying,
    file_template_project_id integer,
    pseudonymizer_enabled boolean DEFAULT false NOT NULL,
    snowplow_enabled boolean DEFAULT false NOT NULL,
    snowplow_collector_uri character varying,
    snowplow_site_id character varying,
    snowplow_cookie_domain character varying,
    custom_project_templates_group_id integer,
    elasticsearch_limit_indexing boolean DEFAULT false NOT NULL,
    geo_node_allowed_ips character varying DEFAULT '0.0.0.0/0, ::/0'::character varying,
    time_tracking_limit_to_hours boolean DEFAULT false NOT NULL,
    grafana_url character varying DEFAULT '/-/grafana'::character varying NOT NULL
);


--
-- Name: application_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.application_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.application_settings_id_seq OWNED BY public.application_settings.id;


--
-- Name: approval_merge_request_rule_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_merge_request_rule_sources (
    id bigint NOT NULL,
    approval_merge_request_rule_id bigint NOT NULL,
    approval_project_rule_id bigint NOT NULL
);


--
-- Name: approval_merge_request_rule_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_merge_request_rule_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_merge_request_rule_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_merge_request_rule_sources_id_seq OWNED BY public.approval_merge_request_rule_sources.id;


--
-- Name: approval_merge_request_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_merge_request_rules (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    merge_request_id integer NOT NULL,
    approvals_required smallint DEFAULT 0 NOT NULL,
    code_owner boolean DEFAULT false NOT NULL,
    name character varying NOT NULL,
    rule_type smallint DEFAULT 1 NOT NULL,
    report_type smallint
);


--
-- Name: approval_merge_request_rules_approved_approvers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_merge_request_rules_approved_approvers (
    id bigint NOT NULL,
    approval_merge_request_rule_id bigint NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: approval_merge_request_rules_approved_approvers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_merge_request_rules_approved_approvers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_merge_request_rules_approved_approvers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_merge_request_rules_approved_approvers_id_seq OWNED BY public.approval_merge_request_rules_approved_approvers.id;


--
-- Name: approval_merge_request_rules_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_merge_request_rules_groups (
    id bigint NOT NULL,
    approval_merge_request_rule_id bigint NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: approval_merge_request_rules_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_merge_request_rules_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_merge_request_rules_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_merge_request_rules_groups_id_seq OWNED BY public.approval_merge_request_rules_groups.id;


--
-- Name: approval_merge_request_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_merge_request_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_merge_request_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_merge_request_rules_id_seq OWNED BY public.approval_merge_request_rules.id;


--
-- Name: approval_merge_request_rules_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_merge_request_rules_users (
    id bigint NOT NULL,
    approval_merge_request_rule_id bigint NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: approval_merge_request_rules_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_merge_request_rules_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_merge_request_rules_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_merge_request_rules_users_id_seq OWNED BY public.approval_merge_request_rules_users.id;


--
-- Name: approval_project_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_project_rules (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer NOT NULL,
    approvals_required smallint DEFAULT 0 NOT NULL,
    name character varying NOT NULL
);


--
-- Name: approval_project_rules_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_project_rules_groups (
    id bigint NOT NULL,
    approval_project_rule_id bigint NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: approval_project_rules_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_project_rules_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_project_rules_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_project_rules_groups_id_seq OWNED BY public.approval_project_rules_groups.id;


--
-- Name: approval_project_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_project_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_project_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_project_rules_id_seq OWNED BY public.approval_project_rules.id;


--
-- Name: approval_project_rules_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approval_project_rules_users (
    id bigint NOT NULL,
    approval_project_rule_id bigint NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: approval_project_rules_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approval_project_rules_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approval_project_rules_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approval_project_rules_users_id_seq OWNED BY public.approval_project_rules_users.id;


--
-- Name: approvals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approvals (
    id integer NOT NULL,
    merge_request_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approvals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approvals_id_seq OWNED BY public.approvals.id;


--
-- Name: approver_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approver_groups (
    id integer NOT NULL,
    target_id integer NOT NULL,
    target_type character varying NOT NULL,
    group_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: approver_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approver_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approver_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approver_groups_id_seq OWNED BY public.approver_groups.id;


--
-- Name: approvers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.approvers (
    id integer NOT NULL,
    target_id integer NOT NULL,
    target_type character varying,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: approvers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.approvers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: approvers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.approvers_id_seq OWNED BY public.approvers.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audit_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_events (
    id integer NOT NULL,
    author_id integer NOT NULL,
    type character varying NOT NULL,
    entity_id integer NOT NULL,
    entity_type character varying NOT NULL,
    details text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: audit_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_events_id_seq OWNED BY public.audit_events.id;


--
-- Name: award_emoji; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.award_emoji (
    id integer NOT NULL,
    name character varying,
    user_id integer,
    awardable_id integer,
    awardable_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: award_emoji_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.award_emoji_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: award_emoji_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.award_emoji_id_seq OWNED BY public.award_emoji.id;


--
-- Name: badges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.badges (
    id integer NOT NULL,
    link_url character varying NOT NULL,
    image_url character varying NOT NULL,
    project_id integer,
    group_id integer,
    type character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: badges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.badges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: badges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.badges_id_seq OWNED BY public.badges.id;


--
-- Name: board_assignees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.board_assignees (
    id integer NOT NULL,
    board_id integer NOT NULL,
    assignee_id integer NOT NULL
);


--
-- Name: board_assignees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.board_assignees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: board_assignees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.board_assignees_id_seq OWNED BY public.board_assignees.id;


--
-- Name: board_group_recent_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.board_group_recent_visits (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer,
    board_id integer,
    group_id integer
);


--
-- Name: board_group_recent_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.board_group_recent_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: board_group_recent_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.board_group_recent_visits_id_seq OWNED BY public.board_group_recent_visits.id;


--
-- Name: board_labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.board_labels (
    id integer NOT NULL,
    board_id integer NOT NULL,
    label_id integer NOT NULL
);


--
-- Name: board_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.board_labels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: board_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.board_labels_id_seq OWNED BY public.board_labels.id;


--
-- Name: board_project_recent_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.board_project_recent_visits (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer,
    project_id integer,
    board_id integer
);


--
-- Name: board_project_recent_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.board_project_recent_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: board_project_recent_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.board_project_recent_visits_id_seq OWNED BY public.board_project_recent_visits.id;


--
-- Name: boards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.boards (
    id integer NOT NULL,
    project_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    group_id integer,
    milestone_id integer,
    weight integer,
    name character varying DEFAULT 'Development'::character varying NOT NULL
);


--
-- Name: boards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.boards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.boards_id_seq OWNED BY public.boards.id;


--
-- Name: broadcast_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.broadcast_messages (
    id integer NOT NULL,
    message text NOT NULL,
    starts_at timestamp without time zone NOT NULL,
    ends_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    color character varying,
    font character varying,
    message_html text NOT NULL,
    cached_markdown_version integer
);


--
-- Name: broadcast_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.broadcast_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: broadcast_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.broadcast_messages_id_seq OWNED BY public.broadcast_messages.id;


--
-- Name: chat_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_names (
    id integer NOT NULL,
    user_id integer NOT NULL,
    service_id integer NOT NULL,
    team_id character varying NOT NULL,
    team_domain character varying,
    chat_id character varying NOT NULL,
    chat_name character varying,
    last_used_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: chat_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_names_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_names_id_seq OWNED BY public.chat_names.id;


--
-- Name: chat_teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.chat_teams (
    id integer NOT NULL,
    namespace_id integer NOT NULL,
    team_id character varying,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: chat_teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.chat_teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: chat_teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.chat_teams_id_seq OWNED BY public.chat_teams.id;


--
-- Name: ci_build_trace_chunks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_build_trace_chunks (
    id bigint NOT NULL,
    build_id integer NOT NULL,
    chunk_index integer NOT NULL,
    data_store integer NOT NULL,
    raw_data bytea
);


--
-- Name: ci_build_trace_chunks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_build_trace_chunks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_build_trace_chunks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_build_trace_chunks_id_seq OWNED BY public.ci_build_trace_chunks.id;


--
-- Name: ci_build_trace_section_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_build_trace_section_names (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: ci_build_trace_section_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_build_trace_section_names_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_build_trace_section_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_build_trace_section_names_id_seq OWNED BY public.ci_build_trace_section_names.id;


--
-- Name: ci_build_trace_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_build_trace_sections (
    id integer NOT NULL,
    project_id integer NOT NULL,
    date_start timestamp with time zone NOT NULL,
    date_end timestamp with time zone NOT NULL,
    byte_start bigint NOT NULL,
    byte_end bigint NOT NULL,
    build_id integer NOT NULL,
    section_name_id integer NOT NULL
);


--
-- Name: ci_build_trace_sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_build_trace_sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_build_trace_sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_build_trace_sections_id_seq OWNED BY public.ci_build_trace_sections.id;


--
-- Name: ci_builds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_builds (
    id integer NOT NULL,
    status character varying,
    finished_at timestamp without time zone,
    trace text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    started_at timestamp without time zone,
    runner_id integer,
    coverage double precision,
    commit_id integer,
    commands text,
    name character varying,
    options text,
    allow_failure boolean DEFAULT false NOT NULL,
    stage character varying,
    trigger_request_id integer,
    stage_idx integer,
    tag boolean,
    ref character varying,
    user_id integer,
    type character varying,
    target_url character varying,
    description character varying,
    artifacts_file text,
    project_id integer,
    artifacts_metadata text,
    erased_by_id integer,
    erased_at timestamp without time zone,
    artifacts_expire_at timestamp without time zone,
    environment character varying,
    artifacts_size bigint,
    "when" character varying,
    yaml_variables text,
    queued_at timestamp without time zone,
    token character varying,
    lock_version integer,
    coverage_regex character varying,
    auto_canceled_by_id integer,
    retried boolean,
    stage_id integer,
    artifacts_file_store integer,
    artifacts_metadata_store integer,
    protected boolean,
    failure_reason integer,
    scheduled_at timestamp with time zone,
    token_encrypted character varying,
    upstream_pipeline_id integer
);


--
-- Name: ci_builds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_builds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_builds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_builds_id_seq OWNED BY public.ci_builds.id;


--
-- Name: ci_builds_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_builds_metadata (
    id integer NOT NULL,
    build_id integer NOT NULL,
    project_id integer NOT NULL,
    timeout integer,
    timeout_source integer DEFAULT 1 NOT NULL,
    config_options jsonb,
    config_variables jsonb
);


--
-- Name: ci_builds_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_builds_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_builds_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_builds_metadata_id_seq OWNED BY public.ci_builds_metadata.id;


--
-- Name: ci_builds_runner_session; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_builds_runner_session (
    id bigint NOT NULL,
    build_id integer NOT NULL,
    url character varying NOT NULL,
    certificate character varying,
    "authorization" character varying
);


--
-- Name: ci_builds_runner_session_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_builds_runner_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_builds_runner_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_builds_runner_session_id_seq OWNED BY public.ci_builds_runner_session.id;


--
-- Name: ci_group_variables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_group_variables (
    id integer NOT NULL,
    key character varying NOT NULL,
    value text,
    encrypted_value text,
    encrypted_value_salt character varying,
    encrypted_value_iv character varying,
    group_id integer NOT NULL,
    protected boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    masked boolean DEFAULT false NOT NULL,
    variable_type smallint DEFAULT 1 NOT NULL
);


--
-- Name: ci_group_variables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_group_variables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_group_variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_group_variables_id_seq OWNED BY public.ci_group_variables.id;


--
-- Name: ci_job_artifacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_job_artifacts (
    id integer NOT NULL,
    project_id integer NOT NULL,
    job_id integer NOT NULL,
    file_type integer NOT NULL,
    file_store integer,
    size bigint,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    expire_at timestamp with time zone,
    file character varying,
    file_sha256 bytea,
    file_format smallint,
    file_location smallint
);


--
-- Name: ci_job_artifacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_job_artifacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_job_artifacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_job_artifacts_id_seq OWNED BY public.ci_job_artifacts.id;


--
-- Name: ci_pipeline_chat_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_pipeline_chat_data (
    id bigint NOT NULL,
    pipeline_id integer NOT NULL,
    chat_name_id integer NOT NULL,
    response_url text NOT NULL
);


--
-- Name: ci_pipeline_chat_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_pipeline_chat_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_pipeline_chat_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_pipeline_chat_data_id_seq OWNED BY public.ci_pipeline_chat_data.id;


--
-- Name: ci_pipeline_schedule_variables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_pipeline_schedule_variables (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value text,
    encrypted_value text,
    encrypted_value_salt character varying,
    encrypted_value_iv character varying,
    pipeline_schedule_id integer NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    variable_type smallint DEFAULT 1 NOT NULL
);


--
-- Name: ci_pipeline_schedule_variables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_pipeline_schedule_variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_pipeline_schedule_variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_pipeline_schedule_variables_id_seq OWNED BY public.ci_pipeline_schedule_variables.id;


--
-- Name: ci_pipeline_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_pipeline_schedules (
    id integer NOT NULL,
    description character varying,
    ref character varying,
    cron character varying,
    cron_timezone character varying,
    next_run_at timestamp without time zone,
    project_id integer,
    owner_id integer,
    active boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: ci_pipeline_schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_pipeline_schedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_pipeline_schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_pipeline_schedules_id_seq OWNED BY public.ci_pipeline_schedules.id;


--
-- Name: ci_pipeline_variables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_pipeline_variables (
    id integer NOT NULL,
    key character varying NOT NULL,
    value text,
    encrypted_value text,
    encrypted_value_salt character varying,
    encrypted_value_iv character varying,
    pipeline_id integer NOT NULL,
    variable_type smallint DEFAULT 1 NOT NULL
);


--
-- Name: ci_pipeline_variables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_pipeline_variables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_pipeline_variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_pipeline_variables_id_seq OWNED BY public.ci_pipeline_variables.id;


--
-- Name: ci_pipelines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_pipelines (
    id integer NOT NULL,
    ref character varying,
    sha character varying,
    before_sha character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    tag boolean DEFAULT false,
    yaml_errors text,
    committed_at timestamp without time zone,
    project_id integer,
    status character varying,
    started_at timestamp without time zone,
    finished_at timestamp without time zone,
    duration integer,
    user_id integer,
    lock_version integer,
    auto_canceled_by_id integer,
    pipeline_schedule_id integer,
    source integer,
    config_source integer,
    protected boolean,
    failure_reason integer,
    iid integer,
    merge_request_id integer,
    source_sha bytea,
    target_sha bytea
);


--
-- Name: ci_pipelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_pipelines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_pipelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_pipelines_id_seq OWNED BY public.ci_pipelines.id;


--
-- Name: ci_runner_namespaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_runner_namespaces (
    id integer NOT NULL,
    runner_id integer,
    namespace_id integer
);


--
-- Name: ci_runner_namespaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_runner_namespaces_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_runner_namespaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_runner_namespaces_id_seq OWNED BY public.ci_runner_namespaces.id;


--
-- Name: ci_runner_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_runner_projects (
    id integer NOT NULL,
    runner_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    project_id integer
);


--
-- Name: ci_runner_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_runner_projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_runner_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_runner_projects_id_seq OWNED BY public.ci_runner_projects.id;


--
-- Name: ci_runners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_runners (
    id integer NOT NULL,
    token character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description character varying,
    contacted_at timestamp without time zone,
    active boolean DEFAULT true NOT NULL,
    is_shared boolean DEFAULT false,
    name character varying,
    version character varying,
    revision character varying,
    platform character varying,
    architecture character varying,
    run_untagged boolean DEFAULT true NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    access_level integer DEFAULT 0 NOT NULL,
    ip_address character varying,
    maximum_timeout integer,
    runner_type smallint NOT NULL,
    token_encrypted character varying
);


--
-- Name: ci_runners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_runners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_runners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_runners_id_seq OWNED BY public.ci_runners.id;


--
-- Name: ci_sources_pipelines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_sources_pipelines (
    id integer NOT NULL,
    project_id integer,
    pipeline_id integer,
    source_project_id integer,
    source_job_id integer,
    source_pipeline_id integer
);


--
-- Name: ci_sources_pipelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_sources_pipelines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_sources_pipelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_sources_pipelines_id_seq OWNED BY public.ci_sources_pipelines.id;


--
-- Name: ci_stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_stages (
    id integer NOT NULL,
    project_id integer,
    pipeline_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying,
    status integer,
    lock_version integer,
    "position" integer
);


--
-- Name: ci_stages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_stages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_stages_id_seq OWNED BY public.ci_stages.id;


--
-- Name: ci_trigger_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_trigger_requests (
    id integer NOT NULL,
    trigger_id integer NOT NULL,
    variables text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    commit_id integer
);


--
-- Name: ci_trigger_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_trigger_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_trigger_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_trigger_requests_id_seq OWNED BY public.ci_trigger_requests.id;


--
-- Name: ci_triggers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_triggers (
    id integer NOT NULL,
    token character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    project_id integer,
    owner_id integer,
    description character varying,
    ref character varying
);


--
-- Name: ci_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_triggers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_triggers_id_seq OWNED BY public.ci_triggers.id;


--
-- Name: ci_variables; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ci_variables (
    id integer NOT NULL,
    key character varying NOT NULL,
    value text,
    encrypted_value text,
    encrypted_value_salt character varying,
    encrypted_value_iv character varying,
    project_id integer NOT NULL,
    protected boolean DEFAULT false NOT NULL,
    environment_scope character varying DEFAULT '*'::character varying NOT NULL,
    masked boolean DEFAULT false NOT NULL,
    variable_type smallint DEFAULT 1 NOT NULL
);


--
-- Name: ci_variables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ci_variables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ci_variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ci_variables_id_seq OWNED BY public.ci_variables.id;


--
-- Name: cluster_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster_groups (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    group_id integer NOT NULL
);


--
-- Name: cluster_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cluster_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cluster_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cluster_groups_id_seq OWNED BY public.cluster_groups.id;


--
-- Name: cluster_platforms_kubernetes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster_platforms_kubernetes (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    api_url text,
    ca_cert text,
    namespace character varying,
    username character varying,
    encrypted_password text,
    encrypted_password_iv character varying,
    encrypted_token text,
    encrypted_token_iv character varying,
    authorization_type smallint
);


--
-- Name: cluster_platforms_kubernetes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cluster_platforms_kubernetes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cluster_platforms_kubernetes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cluster_platforms_kubernetes_id_seq OWNED BY public.cluster_platforms_kubernetes.id;


--
-- Name: cluster_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster_projects (
    id integer NOT NULL,
    project_id integer NOT NULL,
    cluster_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: cluster_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cluster_projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cluster_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cluster_projects_id_seq OWNED BY public.cluster_projects.id;


--
-- Name: cluster_providers_gcp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster_providers_gcp (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    status integer,
    num_nodes integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status_reason text,
    gcp_project_id character varying NOT NULL,
    zone character varying NOT NULL,
    machine_type character varying,
    operation_id character varying,
    endpoint character varying,
    encrypted_access_token text,
    encrypted_access_token_iv character varying,
    legacy_abac boolean DEFAULT false NOT NULL
);


--
-- Name: cluster_providers_gcp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cluster_providers_gcp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cluster_providers_gcp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cluster_providers_gcp_id_seq OWNED BY public.cluster_providers_gcp.id;


--
-- Name: clusters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters (
    id integer NOT NULL,
    user_id integer,
    provider_type integer,
    platform_type integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    enabled boolean DEFAULT true,
    name character varying NOT NULL,
    environment_scope character varying DEFAULT '*'::character varying NOT NULL,
    cluster_type smallint DEFAULT 3 NOT NULL,
    domain character varying,
    managed boolean DEFAULT true NOT NULL
);


--
-- Name: clusters_applications_cert_managers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters_applications_cert_managers (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    status integer NOT NULL,
    version character varying NOT NULL,
    email character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status_reason text
);


--
-- Name: clusters_applications_cert_managers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_applications_cert_managers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_applications_cert_managers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_applications_cert_managers_id_seq OWNED BY public.clusters_applications_cert_managers.id;


--
-- Name: clusters_applications_helm; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters_applications_helm (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status integer NOT NULL,
    version character varying NOT NULL,
    status_reason text,
    encrypted_ca_key text,
    encrypted_ca_key_iv text,
    ca_cert text
);


--
-- Name: clusters_applications_helm_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_applications_helm_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_applications_helm_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_applications_helm_id_seq OWNED BY public.clusters_applications_helm.id;


--
-- Name: clusters_applications_ingress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters_applications_ingress (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status integer NOT NULL,
    ingress_type integer NOT NULL,
    version character varying NOT NULL,
    cluster_ip character varying,
    status_reason text,
    external_ip character varying,
    external_hostname character varying
);


--
-- Name: clusters_applications_ingress_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_applications_ingress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_applications_ingress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_applications_ingress_id_seq OWNED BY public.clusters_applications_ingress.id;


--
-- Name: clusters_applications_jupyter; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters_applications_jupyter (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    oauth_application_id integer,
    status integer NOT NULL,
    version character varying NOT NULL,
    hostname character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status_reason text
);


--
-- Name: clusters_applications_jupyter_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_applications_jupyter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_applications_jupyter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_applications_jupyter_id_seq OWNED BY public.clusters_applications_jupyter.id;


--
-- Name: clusters_applications_knative; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters_applications_knative (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    status integer NOT NULL,
    version character varying NOT NULL,
    hostname character varying,
    status_reason text,
    external_ip character varying,
    external_hostname character varying
);


--
-- Name: clusters_applications_knative_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_applications_knative_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_applications_knative_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_applications_knative_id_seq OWNED BY public.clusters_applications_knative.id;


--
-- Name: clusters_applications_prometheus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters_applications_prometheus (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    status integer NOT NULL,
    version character varying NOT NULL,
    status_reason text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    encrypted_alert_manager_token character varying,
    encrypted_alert_manager_token_iv character varying,
    last_update_started_at timestamp with time zone
);


--
-- Name: clusters_applications_prometheus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_applications_prometheus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_applications_prometheus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_applications_prometheus_id_seq OWNED BY public.clusters_applications_prometheus.id;


--
-- Name: clusters_applications_runners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters_applications_runners (
    id integer NOT NULL,
    cluster_id integer NOT NULL,
    runner_id integer,
    status integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    version character varying NOT NULL,
    status_reason text,
    privileged boolean DEFAULT true NOT NULL
);


--
-- Name: clusters_applications_runners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_applications_runners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_applications_runners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_applications_runners_id_seq OWNED BY public.clusters_applications_runners.id;


--
-- Name: clusters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_id_seq OWNED BY public.clusters.id;


--
-- Name: clusters_kubernetes_namespaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusters_kubernetes_namespaces (
    id bigint NOT NULL,
    cluster_id integer NOT NULL,
    project_id integer,
    cluster_project_id integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    encrypted_service_account_token text,
    encrypted_service_account_token_iv character varying,
    namespace character varying NOT NULL,
    service_account_name character varying
);


--
-- Name: clusters_kubernetes_namespaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusters_kubernetes_namespaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusters_kubernetes_namespaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusters_kubernetes_namespaces_id_seq OWNED BY public.clusters_kubernetes_namespaces.id;


--
-- Name: container_repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.container_repositories (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: container_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.container_repositories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: container_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.container_repositories_id_seq OWNED BY public.container_repositories.id;


--
-- Name: conversational_development_index_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversational_development_index_metrics (
    id integer NOT NULL,
    leader_issues double precision NOT NULL,
    instance_issues double precision NOT NULL,
    leader_notes double precision NOT NULL,
    instance_notes double precision NOT NULL,
    leader_milestones double precision NOT NULL,
    instance_milestones double precision NOT NULL,
    leader_boards double precision NOT NULL,
    instance_boards double precision NOT NULL,
    leader_merge_requests double precision NOT NULL,
    instance_merge_requests double precision NOT NULL,
    leader_ci_pipelines double precision NOT NULL,
    instance_ci_pipelines double precision NOT NULL,
    leader_environments double precision NOT NULL,
    instance_environments double precision NOT NULL,
    leader_deployments double precision NOT NULL,
    instance_deployments double precision NOT NULL,
    leader_projects_prometheus_active double precision NOT NULL,
    instance_projects_prometheus_active double precision NOT NULL,
    leader_service_desk_issues double precision NOT NULL,
    instance_service_desk_issues double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    percentage_boards double precision DEFAULT 0.0 NOT NULL,
    percentage_ci_pipelines double precision DEFAULT 0.0 NOT NULL,
    percentage_deployments double precision DEFAULT 0.0 NOT NULL,
    percentage_environments double precision DEFAULT 0.0 NOT NULL,
    percentage_issues double precision DEFAULT 0.0 NOT NULL,
    percentage_merge_requests double precision DEFAULT 0.0 NOT NULL,
    percentage_milestones double precision DEFAULT 0.0 NOT NULL,
    percentage_notes double precision DEFAULT 0.0 NOT NULL,
    percentage_projects_prometheus_active double precision DEFAULT 0.0 NOT NULL,
    percentage_service_desk_issues double precision DEFAULT 0.0 NOT NULL
);


--
-- Name: conversational_development_index_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conversational_development_index_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversational_development_index_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conversational_development_index_metrics_id_seq OWNED BY public.conversational_development_index_metrics.id;


--
-- Name: dependency_proxy_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dependency_proxy_blobs (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    file text NOT NULL,
    file_name character varying NOT NULL,
    file_store integer,
    group_id integer NOT NULL,
    size bigint,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: dependency_proxy_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dependency_proxy_blobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dependency_proxy_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dependency_proxy_blobs_id_seq OWNED BY public.dependency_proxy_blobs.id;


--
-- Name: dependency_proxy_group_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dependency_proxy_group_settings (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    group_id integer NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: dependency_proxy_group_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dependency_proxy_group_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dependency_proxy_group_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dependency_proxy_group_settings_id_seq OWNED BY public.dependency_proxy_group_settings.id;


--
-- Name: deploy_keys_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deploy_keys_projects (
    id integer NOT NULL,
    deploy_key_id integer NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    can_push boolean DEFAULT false NOT NULL
);


--
-- Name: deploy_keys_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deploy_keys_projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deploy_keys_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deploy_keys_projects_id_seq OWNED BY public.deploy_keys_projects.id;


--
-- Name: deploy_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deploy_tokens (
    id integer NOT NULL,
    revoked boolean DEFAULT false,
    read_repository boolean DEFAULT false NOT NULL,
    read_registry boolean DEFAULT false NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    name character varying NOT NULL,
    token character varying NOT NULL,
    username character varying
);


--
-- Name: deploy_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deploy_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deploy_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deploy_tokens_id_seq OWNED BY public.deploy_tokens.id;


--
-- Name: deployments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deployments (
    id integer NOT NULL,
    iid integer NOT NULL,
    project_id integer NOT NULL,
    environment_id integer NOT NULL,
    ref character varying NOT NULL,
    tag boolean NOT NULL,
    sha character varying NOT NULL,
    user_id integer,
    deployable_id integer,
    deployable_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    on_stop character varying,
    status smallint NOT NULL,
    finished_at timestamp with time zone,
    cluster_id integer
);


--
-- Name: deployments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deployments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deployments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deployments_id_seq OWNED BY public.deployments.id;


--
-- Name: design_management_designs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.design_management_designs (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    issue_id integer NOT NULL,
    filename character varying NOT NULL
);


--
-- Name: design_management_designs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.design_management_designs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: design_management_designs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.design_management_designs_id_seq OWNED BY public.design_management_designs.id;


--
-- Name: design_management_designs_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.design_management_designs_versions (
    design_id bigint NOT NULL,
    version_id bigint NOT NULL
);


--
-- Name: design_management_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.design_management_versions (
    id bigint NOT NULL,
    sha bytea NOT NULL
);


--
-- Name: design_management_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.design_management_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: design_management_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.design_management_versions_id_seq OWNED BY public.design_management_versions.id;


--
-- Name: draft_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.draft_notes (
    id bigint NOT NULL,
    merge_request_id integer NOT NULL,
    author_id integer NOT NULL,
    resolve_discussion boolean DEFAULT false NOT NULL,
    discussion_id character varying,
    note text NOT NULL,
    "position" text,
    original_position text,
    change_position text
);


--
-- Name: draft_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.draft_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: draft_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.draft_notes_id_seq OWNED BY public.draft_notes.id;


--
-- Name: elasticsearch_indexed_namespaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.elasticsearch_indexed_namespaces (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    namespace_id integer
);


--
-- Name: elasticsearch_indexed_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.elasticsearch_indexed_projects (
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer
);


--
-- Name: emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.emails (
    id integer NOT NULL,
    user_id integer NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp with time zone,
    confirmation_sent_at timestamp with time zone
);


--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.emails_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.emails_id_seq OWNED BY public.emails.id;


--
-- Name: environments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.environments (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    external_url character varying,
    environment_type character varying,
    state character varying DEFAULT 'available'::character varying NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: environments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.environments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: environments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.environments_id_seq OWNED BY public.environments.id;


--
-- Name: epic_issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epic_issues (
    id integer NOT NULL,
    epic_id integer NOT NULL,
    issue_id integer NOT NULL,
    relative_position integer DEFAULT 1073741823 NOT NULL
);


--
-- Name: epic_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epic_issues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: epic_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epic_issues_id_seq OWNED BY public.epic_issues.id;


--
-- Name: epic_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epic_metrics (
    id integer NOT NULL,
    epic_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: epic_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epic_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: epic_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epic_metrics_id_seq OWNED BY public.epic_metrics.id;


--
-- Name: epics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.epics (
    id integer NOT NULL,
    milestone_id integer,
    group_id integer NOT NULL,
    author_id integer NOT NULL,
    assignee_id integer,
    iid integer NOT NULL,
    cached_markdown_version integer,
    updated_by_id integer,
    last_edited_by_id integer,
    lock_version integer,
    start_date date,
    end_date date,
    last_edited_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying NOT NULL,
    title_html character varying NOT NULL,
    description text,
    description_html text,
    start_date_sourcing_milestone_id integer,
    due_date_sourcing_milestone_id integer,
    start_date_fixed date,
    due_date_fixed date,
    start_date_is_fixed boolean,
    due_date_is_fixed boolean,
    state smallint DEFAULT 1 NOT NULL,
    closed_by_id integer,
    closed_at timestamp without time zone,
    parent_id integer,
    relative_position integer
);


--
-- Name: epics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.epics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: epics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.epics_id_seq OWNED BY public.epics.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    project_id integer,
    author_id integer NOT NULL,
    target_id integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    action smallint NOT NULL,
    target_type character varying
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: feature_gates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.feature_gates (
    id integer NOT NULL,
    feature_key character varying NOT NULL,
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: feature_gates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.feature_gates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feature_gates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.feature_gates_id_seq OWNED BY public.feature_gates.id;


--
-- Name: features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.features (
    id integer NOT NULL,
    key character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.features_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.features_id_seq OWNED BY public.features.id;


--
-- Name: fork_network_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fork_network_members (
    id integer NOT NULL,
    fork_network_id integer NOT NULL,
    project_id integer NOT NULL,
    forked_from_project_id integer
);


--
-- Name: fork_network_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fork_network_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fork_network_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fork_network_members_id_seq OWNED BY public.fork_network_members.id;


--
-- Name: fork_networks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fork_networks (
    id integer NOT NULL,
    root_project_id integer,
    deleted_root_project_name character varying
);


--
-- Name: fork_networks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fork_networks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fork_networks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fork_networks_id_seq OWNED BY public.fork_networks.id;


--
-- Name: forked_project_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.forked_project_links (
    id integer NOT NULL,
    forked_to_project_id integer NOT NULL,
    forked_from_project_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: forked_project_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.forked_project_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forked_project_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.forked_project_links_id_seq OWNED BY public.forked_project_links.id;


--
-- Name: geo_cache_invalidation_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_cache_invalidation_events (
    id bigint NOT NULL,
    key character varying NOT NULL
);


--
-- Name: geo_cache_invalidation_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_cache_invalidation_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_cache_invalidation_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_cache_invalidation_events_id_seq OWNED BY public.geo_cache_invalidation_events.id;


--
-- Name: geo_event_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_event_log (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    repository_updated_event_id bigint,
    repository_deleted_event_id bigint,
    repository_renamed_event_id bigint,
    repositories_changed_event_id bigint,
    repository_created_event_id bigint,
    hashed_storage_migrated_event_id bigint,
    lfs_object_deleted_event_id bigint,
    hashed_storage_attachments_event_id bigint,
    upload_deleted_event_id bigint,
    job_artifact_deleted_event_id bigint,
    reset_checksum_event_id bigint,
    cache_invalidation_event_id bigint
);


--
-- Name: geo_event_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_event_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_event_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_event_log_id_seq OWNED BY public.geo_event_log.id;


--
-- Name: geo_hashed_storage_attachments_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_hashed_storage_attachments_events (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    old_attachments_path text NOT NULL,
    new_attachments_path text NOT NULL
);


--
-- Name: geo_hashed_storage_attachments_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_hashed_storage_attachments_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_hashed_storage_attachments_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_hashed_storage_attachments_events_id_seq OWNED BY public.geo_hashed_storage_attachments_events.id;


--
-- Name: geo_hashed_storage_migrated_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_hashed_storage_migrated_events (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    repository_storage_name text NOT NULL,
    old_disk_path text NOT NULL,
    new_disk_path text NOT NULL,
    old_wiki_disk_path text NOT NULL,
    new_wiki_disk_path text NOT NULL,
    old_storage_version smallint,
    new_storage_version smallint NOT NULL
);


--
-- Name: geo_hashed_storage_migrated_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_hashed_storage_migrated_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_hashed_storage_migrated_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_hashed_storage_migrated_events_id_seq OWNED BY public.geo_hashed_storage_migrated_events.id;


--
-- Name: geo_job_artifact_deleted_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_job_artifact_deleted_events (
    id bigint NOT NULL,
    job_artifact_id integer NOT NULL,
    file_path character varying NOT NULL
);


--
-- Name: geo_job_artifact_deleted_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_job_artifact_deleted_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_job_artifact_deleted_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_job_artifact_deleted_events_id_seq OWNED BY public.geo_job_artifact_deleted_events.id;


--
-- Name: geo_lfs_object_deleted_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_lfs_object_deleted_events (
    id bigint NOT NULL,
    lfs_object_id integer NOT NULL,
    oid character varying NOT NULL,
    file_path character varying NOT NULL
);


--
-- Name: geo_lfs_object_deleted_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_lfs_object_deleted_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_lfs_object_deleted_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_lfs_object_deleted_events_id_seq OWNED BY public.geo_lfs_object_deleted_events.id;


--
-- Name: geo_node_namespace_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_node_namespace_links (
    id integer NOT NULL,
    geo_node_id integer NOT NULL,
    namespace_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: geo_node_namespace_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_node_namespace_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_node_namespace_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_node_namespace_links_id_seq OWNED BY public.geo_node_namespace_links.id;


--
-- Name: geo_node_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_node_statuses (
    id integer NOT NULL,
    geo_node_id integer NOT NULL,
    db_replication_lag_seconds integer,
    repositories_synced_count integer,
    repositories_failed_count integer,
    lfs_objects_count integer,
    lfs_objects_synced_count integer,
    lfs_objects_failed_count integer,
    attachments_count integer,
    attachments_synced_count integer,
    attachments_failed_count integer,
    last_event_id integer,
    last_event_date timestamp without time zone,
    cursor_last_event_id integer,
    cursor_last_event_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_successful_status_check_at timestamp without time zone,
    status_message character varying,
    replication_slots_count integer,
    replication_slots_used_count integer,
    replication_slots_max_retained_wal_bytes bigint,
    wikis_synced_count integer,
    wikis_failed_count integer,
    job_artifacts_count integer,
    job_artifacts_synced_count integer,
    job_artifacts_failed_count integer,
    version character varying,
    revision character varying,
    repositories_verified_count integer,
    repositories_verification_failed_count integer,
    wikis_verified_count integer,
    wikis_verification_failed_count integer,
    lfs_objects_synced_missing_on_primary_count integer,
    job_artifacts_synced_missing_on_primary_count integer,
    attachments_synced_missing_on_primary_count integer,
    repositories_checksummed_count integer,
    repositories_checksum_failed_count integer,
    repositories_checksum_mismatch_count integer,
    wikis_checksummed_count integer,
    wikis_checksum_failed_count integer,
    wikis_checksum_mismatch_count integer,
    storage_configuration_digest bytea,
    repositories_retrying_verification_count integer,
    wikis_retrying_verification_count integer,
    projects_count integer
);


--
-- Name: geo_node_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_node_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_node_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_node_statuses_id_seq OWNED BY public.geo_node_statuses.id;


--
-- Name: geo_nodes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_nodes (
    id integer NOT NULL,
    "primary" boolean DEFAULT false NOT NULL,
    oauth_application_id integer,
    enabled boolean DEFAULT true NOT NULL,
    access_key character varying,
    encrypted_secret_access_key character varying,
    encrypted_secret_access_key_iv character varying,
    clone_url_prefix character varying,
    files_max_capacity integer DEFAULT 10 NOT NULL,
    repos_max_capacity integer DEFAULT 25 NOT NULL,
    url character varying NOT NULL,
    selective_sync_type character varying,
    selective_sync_shards text,
    verification_max_capacity integer DEFAULT 100 NOT NULL,
    minimum_reverification_interval integer DEFAULT 7 NOT NULL,
    internal_url character varying,
    name character varying NOT NULL
);


--
-- Name: geo_nodes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_nodes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_nodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_nodes_id_seq OWNED BY public.geo_nodes.id;


--
-- Name: geo_repositories_changed_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_repositories_changed_events (
    id bigint NOT NULL,
    geo_node_id integer NOT NULL
);


--
-- Name: geo_repositories_changed_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_repositories_changed_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_repositories_changed_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_repositories_changed_events_id_seq OWNED BY public.geo_repositories_changed_events.id;


--
-- Name: geo_repository_created_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_repository_created_events (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    repository_storage_name text NOT NULL,
    repo_path text NOT NULL,
    wiki_path text,
    project_name text NOT NULL
);


--
-- Name: geo_repository_created_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_repository_created_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_repository_created_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_repository_created_events_id_seq OWNED BY public.geo_repository_created_events.id;


--
-- Name: geo_repository_deleted_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_repository_deleted_events (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    repository_storage_name text NOT NULL,
    deleted_path text NOT NULL,
    deleted_wiki_path text,
    deleted_project_name text NOT NULL
);


--
-- Name: geo_repository_deleted_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_repository_deleted_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_repository_deleted_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_repository_deleted_events_id_seq OWNED BY public.geo_repository_deleted_events.id;


--
-- Name: geo_repository_renamed_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_repository_renamed_events (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    repository_storage_name text NOT NULL,
    old_path_with_namespace text NOT NULL,
    new_path_with_namespace text NOT NULL,
    old_wiki_path_with_namespace text NOT NULL,
    new_wiki_path_with_namespace text NOT NULL,
    old_path text NOT NULL,
    new_path text NOT NULL
);


--
-- Name: geo_repository_renamed_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_repository_renamed_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_repository_renamed_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_repository_renamed_events_id_seq OWNED BY public.geo_repository_renamed_events.id;


--
-- Name: geo_repository_updated_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_repository_updated_events (
    id bigint NOT NULL,
    branches_affected integer NOT NULL,
    tags_affected integer NOT NULL,
    project_id integer NOT NULL,
    source smallint NOT NULL,
    new_branch boolean DEFAULT false NOT NULL,
    remove_branch boolean DEFAULT false NOT NULL,
    ref text
);


--
-- Name: geo_repository_updated_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_repository_updated_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_repository_updated_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_repository_updated_events_id_seq OWNED BY public.geo_repository_updated_events.id;


--
-- Name: geo_reset_checksum_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_reset_checksum_events (
    id bigint NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: geo_reset_checksum_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_reset_checksum_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_reset_checksum_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_reset_checksum_events_id_seq OWNED BY public.geo_reset_checksum_events.id;


--
-- Name: geo_upload_deleted_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_upload_deleted_events (
    id bigint NOT NULL,
    upload_id integer NOT NULL,
    file_path character varying NOT NULL,
    model_id integer NOT NULL,
    model_type character varying NOT NULL,
    uploader character varying NOT NULL
);


--
-- Name: geo_upload_deleted_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_upload_deleted_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_upload_deleted_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_upload_deleted_events_id_seq OWNED BY public.geo_upload_deleted_events.id;


--
-- Name: gitlab_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gitlab_subscriptions (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    start_date date,
    end_date date,
    trial_ends_on date,
    namespace_id integer,
    hosted_plan_id integer,
    max_seats_used integer DEFAULT 0,
    seats integer DEFAULT 0,
    trial boolean DEFAULT false
);


--
-- Name: gitlab_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gitlab_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gitlab_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gitlab_subscriptions_id_seq OWNED BY public.gitlab_subscriptions.id;


--
-- Name: gpg_key_subkeys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gpg_key_subkeys (
    id integer NOT NULL,
    gpg_key_id integer NOT NULL,
    keyid bytea,
    fingerprint bytea
);


--
-- Name: gpg_key_subkeys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gpg_key_subkeys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gpg_key_subkeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gpg_key_subkeys_id_seq OWNED BY public.gpg_key_subkeys.id;


--
-- Name: gpg_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gpg_keys (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer,
    primary_keyid bytea,
    fingerprint bytea,
    key text
);


--
-- Name: gpg_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gpg_keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gpg_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gpg_keys_id_seq OWNED BY public.gpg_keys.id;


--
-- Name: gpg_signatures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gpg_signatures (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer,
    gpg_key_id integer,
    commit_sha bytea,
    gpg_key_primary_keyid bytea,
    gpg_key_user_name text,
    gpg_key_user_email text,
    verification_status smallint DEFAULT 0 NOT NULL,
    gpg_key_subkey_id integer
);


--
-- Name: gpg_signatures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gpg_signatures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gpg_signatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gpg_signatures_id_seq OWNED BY public.gpg_signatures.id;


--
-- Name: group_custom_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_custom_attributes (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    group_id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL
);


--
-- Name: group_custom_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_custom_attributes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_custom_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_custom_attributes_id_seq OWNED BY public.group_custom_attributes.id;


--
-- Name: historical_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historical_data (
    id integer NOT NULL,
    date date NOT NULL,
    active_user_count integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: historical_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.historical_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historical_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.historical_data_id_seq OWNED BY public.historical_data.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
    id integer NOT NULL,
    extern_uid character varying,
    provider character varying,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    saml_provider_id integer,
    secondary_extern_uid character varying
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.identities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.identities_id_seq OWNED BY public.identities.id;


--
-- Name: import_export_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.import_export_uploads (
    id integer NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer,
    import_file text,
    export_file text
);


--
-- Name: import_export_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.import_export_uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: import_export_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.import_export_uploads_id_seq OWNED BY public.import_export_uploads.id;


--
-- Name: index_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.index_statuses (
    id integer NOT NULL,
    project_id integer NOT NULL,
    indexed_at timestamp without time zone,
    note text,
    last_commit character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_wiki_commit bytea,
    wiki_indexed_at timestamp with time zone
);


--
-- Name: index_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.index_statuses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: index_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.index_statuses_id_seq OWNED BY public.index_statuses.id;


--
-- Name: insights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.insights (
    id integer NOT NULL,
    namespace_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: insights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.insights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.insights_id_seq OWNED BY public.insights.id;


--
-- Name: internal_ids; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.internal_ids (
    id bigint NOT NULL,
    project_id integer,
    usage integer NOT NULL,
    last_value integer NOT NULL,
    namespace_id integer
);


--
-- Name: internal_ids_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.internal_ids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: internal_ids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.internal_ids_id_seq OWNED BY public.internal_ids.id;


--
-- Name: ip_restrictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ip_restrictions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    range character varying NOT NULL
);


--
-- Name: ip_restrictions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ip_restrictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ip_restrictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ip_restrictions_id_seq OWNED BY public.ip_restrictions.id;


--
-- Name: issue_assignees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.issue_assignees (
    user_id integer NOT NULL,
    issue_id integer NOT NULL
);


--
-- Name: issue_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.issue_links (
    id integer NOT NULL,
    source_id integer NOT NULL,
    target_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: issue_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.issue_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.issue_links_id_seq OWNED BY public.issue_links.id;


--
-- Name: issue_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.issue_metrics (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    first_mentioned_in_commit_at timestamp without time zone,
    first_associated_with_milestone_at timestamp without time zone,
    first_added_to_board_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: issue_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.issue_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.issue_metrics_id_seq OWNED BY public.issue_metrics.id;


--
-- Name: issue_tracker_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.issue_tracker_data (
    id bigint NOT NULL,
    service_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    encrypted_project_url character varying,
    encrypted_project_url_iv character varying,
    encrypted_issues_url character varying,
    encrypted_issues_url_iv character varying,
    encrypted_new_issue_url character varying,
    encrypted_new_issue_url_iv character varying
);


--
-- Name: issue_tracker_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.issue_tracker_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_tracker_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.issue_tracker_data_id_seq OWNED BY public.issue_tracker_data.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.issues (
    id integer NOT NULL,
    title character varying,
    author_id integer,
    project_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text,
    milestone_id integer,
    state character varying,
    iid integer,
    updated_by_id integer,
    confidential boolean DEFAULT false NOT NULL,
    due_date date,
    moved_to_id integer,
    lock_version integer,
    title_html text,
    description_html text,
    time_estimate integer,
    relative_position integer,
    cached_markdown_version integer,
    last_edited_at timestamp without time zone,
    last_edited_by_id integer,
    discussion_locked boolean,
    closed_at timestamp with time zone,
    closed_by_id integer,
    state_id smallint,
    service_desk_reply_to character varying,
    weight integer
);


--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.issues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.issues_id_seq OWNED BY public.issues.id;


--
-- Name: jira_connect_installations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jira_connect_installations (
    id bigint NOT NULL,
    client_key character varying,
    encrypted_shared_secret character varying,
    encrypted_shared_secret_iv character varying,
    base_url character varying
);


--
-- Name: jira_connect_installations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jira_connect_installations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_connect_installations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jira_connect_installations_id_seq OWNED BY public.jira_connect_installations.id;


--
-- Name: jira_connect_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jira_connect_subscriptions (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    jira_connect_installation_id bigint NOT NULL,
    namespace_id integer NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: jira_connect_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jira_connect_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_connect_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jira_connect_subscriptions_id_seq OWNED BY public.jira_connect_subscriptions.id;


--
-- Name: jira_tracker_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jira_tracker_data (
    id bigint NOT NULL,
    service_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    encrypted_url character varying,
    encrypted_url_iv character varying,
    encrypted_api_url character varying,
    encrypted_api_url_iv character varying,
    encrypted_username character varying,
    encrypted_username_iv character varying,
    encrypted_password character varying,
    encrypted_password_iv character varying,
    jira_issue_transition_id character varying
);


--
-- Name: jira_tracker_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jira_tracker_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_tracker_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jira_tracker_data_id_seq OWNED BY public.jira_tracker_data.id;


--
-- Name: keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.keys (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    key text,
    title character varying,
    type character varying,
    fingerprint character varying,
    public boolean DEFAULT false NOT NULL,
    last_used_at timestamp without time zone
);


--
-- Name: keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.keys_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.keys_id_seq OWNED BY public.keys.id;


--
-- Name: label_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.label_links (
    id integer NOT NULL,
    label_id integer,
    target_id integer,
    target_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: label_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.label_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: label_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.label_links_id_seq OWNED BY public.label_links.id;


--
-- Name: label_priorities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.label_priorities (
    id integer NOT NULL,
    project_id integer NOT NULL,
    label_id integer NOT NULL,
    priority integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: label_priorities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.label_priorities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: label_priorities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.label_priorities_id_seq OWNED BY public.label_priorities.id;


--
-- Name: labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.labels (
    id integer NOT NULL,
    title character varying,
    color character varying,
    project_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    template boolean DEFAULT false,
    description character varying,
    description_html text,
    type character varying,
    group_id integer,
    cached_markdown_version integer
);


--
-- Name: labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.labels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.labels_id_seq OWNED BY public.labels.id;


--
-- Name: ldap_group_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ldap_group_links (
    id integer NOT NULL,
    cn character varying,
    group_access integer NOT NULL,
    group_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    provider character varying,
    filter character varying
);


--
-- Name: ldap_group_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ldap_group_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ldap_group_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ldap_group_links_id_seq OWNED BY public.ldap_group_links.id;


--
-- Name: lfs_file_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lfs_file_locks (
    id integer NOT NULL,
    project_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    path character varying(511)
);


--
-- Name: lfs_file_locks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lfs_file_locks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lfs_file_locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lfs_file_locks_id_seq OWNED BY public.lfs_file_locks.id;


--
-- Name: lfs_objects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lfs_objects (
    id integer NOT NULL,
    oid character varying NOT NULL,
    size bigint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    file character varying,
    file_store integer
);


--
-- Name: lfs_objects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lfs_objects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lfs_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lfs_objects_id_seq OWNED BY public.lfs_objects.id;


--
-- Name: lfs_objects_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lfs_objects_projects (
    id integer NOT NULL,
    lfs_object_id integer NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    repository_type smallint
);


--
-- Name: lfs_objects_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lfs_objects_projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lfs_objects_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lfs_objects_projects_id_seq OWNED BY public.lfs_objects_projects.id;


--
-- Name: licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.licenses (
    id integer NOT NULL,
    data text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.licenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.licenses_id_seq OWNED BY public.licenses.id;


--
-- Name: lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.lists (
    id integer NOT NULL,
    board_id integer NOT NULL,
    label_id integer,
    list_type integer DEFAULT 1 NOT NULL,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    milestone_id integer,
    user_id integer
);


--
-- Name: lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.lists_id_seq OWNED BY public.lists.id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.members (
    id integer NOT NULL,
    access_level integer NOT NULL,
    source_id integer NOT NULL,
    source_type character varying NOT NULL,
    user_id integer,
    notification_level integer NOT NULL,
    type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by_id integer,
    invite_email character varying,
    invite_token character varying,
    invite_accepted_at timestamp without time zone,
    requested_at timestamp without time zone,
    expires_at date,
    ldap boolean DEFAULT false NOT NULL,
    override boolean DEFAULT false NOT NULL
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.members.id;


--
-- Name: merge_request_assignees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_request_assignees (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    merge_request_id integer NOT NULL
);


--
-- Name: merge_request_assignees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.merge_request_assignees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merge_request_assignees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.merge_request_assignees_id_seq OWNED BY public.merge_request_assignees.id;


--
-- Name: merge_request_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_request_blocks (
    id bigint NOT NULL,
    blocking_merge_request_id integer NOT NULL,
    blocked_merge_request_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: merge_request_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.merge_request_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merge_request_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.merge_request_blocks_id_seq OWNED BY public.merge_request_blocks.id;


--
-- Name: merge_request_diff_commits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_request_diff_commits (
    authored_date timestamp with time zone,
    committed_date timestamp with time zone,
    merge_request_diff_id integer NOT NULL,
    relative_order integer NOT NULL,
    sha bytea NOT NULL,
    author_name text,
    author_email text,
    committer_name text,
    committer_email text,
    message text
);


--
-- Name: merge_request_diff_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_request_diff_files (
    merge_request_diff_id integer NOT NULL,
    relative_order integer NOT NULL,
    new_file boolean NOT NULL,
    renamed_file boolean NOT NULL,
    deleted_file boolean NOT NULL,
    too_large boolean NOT NULL,
    a_mode character varying NOT NULL,
    b_mode character varying NOT NULL,
    new_path text NOT NULL,
    old_path text NOT NULL,
    diff text,
    "binary" boolean,
    external_diff_offset integer,
    external_diff_size integer
);


--
-- Name: merge_request_diffs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_request_diffs (
    id integer NOT NULL,
    state character varying,
    merge_request_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    base_commit_sha character varying,
    real_size character varying,
    head_commit_sha character varying,
    start_commit_sha character varying,
    commits_count integer,
    external_diff character varying,
    external_diff_store integer,
    stored_externally boolean
);


--
-- Name: merge_request_diffs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.merge_request_diffs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merge_request_diffs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.merge_request_diffs_id_seq OWNED BY public.merge_request_diffs.id;


--
-- Name: merge_request_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_request_metrics (
    id integer NOT NULL,
    merge_request_id integer NOT NULL,
    latest_build_started_at timestamp without time zone,
    latest_build_finished_at timestamp without time zone,
    first_deployed_to_production_at timestamp without time zone,
    merged_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    pipeline_id integer,
    merged_by_id integer,
    latest_closed_by_id integer,
    latest_closed_at timestamp with time zone
);


--
-- Name: merge_request_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.merge_request_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merge_request_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.merge_request_metrics_id_seq OWNED BY public.merge_request_metrics.id;


--
-- Name: merge_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_requests (
    id integer NOT NULL,
    target_branch character varying NOT NULL,
    source_branch character varying NOT NULL,
    source_project_id integer,
    author_id integer,
    assignee_id integer,
    title character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    milestone_id integer,
    state character varying DEFAULT 'opened'::character varying NOT NULL,
    merge_status character varying DEFAULT 'unchecked'::character varying NOT NULL,
    target_project_id integer NOT NULL,
    iid integer,
    description text,
    updated_by_id integer,
    merge_error text,
    merge_params text,
    merge_when_pipeline_succeeds boolean DEFAULT false NOT NULL,
    merge_user_id integer,
    merge_commit_sha character varying,
    in_progress_merge_commit_sha character varying,
    lock_version integer,
    title_html text,
    description_html text,
    time_estimate integer,
    cached_markdown_version integer,
    last_edited_at timestamp without time zone,
    last_edited_by_id integer,
    head_pipeline_id integer,
    merge_jid character varying,
    discussion_locked boolean,
    latest_merge_request_diff_id integer,
    rebase_commit_sha character varying,
    squash boolean DEFAULT false NOT NULL,
    allow_maintainer_to_push boolean,
    state_id smallint,
    approvals_before_merge integer,
    rebase_jid character varying
);


--
-- Name: merge_requests_closing_issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_requests_closing_issues (
    id integer NOT NULL,
    merge_request_id integer NOT NULL,
    issue_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: merge_requests_closing_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.merge_requests_closing_issues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merge_requests_closing_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.merge_requests_closing_issues_id_seq OWNED BY public.merge_requests_closing_issues.id;


--
-- Name: merge_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.merge_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merge_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.merge_requests_id_seq OWNED BY public.merge_requests.id;


--
-- Name: merge_trains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_trains (
    id bigint NOT NULL,
    merge_request_id integer NOT NULL,
    user_id integer NOT NULL,
    pipeline_id integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    target_project_id integer NOT NULL,
    target_branch text NOT NULL
);


--
-- Name: merge_trains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.merge_trains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merge_trains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.merge_trains_id_seq OWNED BY public.merge_trains.id;


--
-- Name: milestones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.milestones (
    id integer NOT NULL,
    title character varying NOT NULL,
    project_id integer,
    description text,
    due_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    state character varying,
    iid integer,
    title_html text,
    description_html text,
    start_date date,
    cached_markdown_version integer,
    group_id integer
);


--
-- Name: milestones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.milestones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.milestones_id_seq OWNED BY public.milestones.id;


--
-- Name: namespace_aggregation_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_aggregation_schedules (
    namespace_id integer NOT NULL
);


--
-- Name: namespace_root_storage_statistics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_root_storage_statistics (
    namespace_id integer NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    repository_size bigint DEFAULT 0 NOT NULL,
    lfs_objects_size bigint DEFAULT 0 NOT NULL,
    wiki_size bigint DEFAULT 0 NOT NULL,
    build_artifacts_size bigint DEFAULT 0 NOT NULL,
    storage_size bigint DEFAULT 0 NOT NULL,
    packages_size bigint DEFAULT 0 NOT NULL
);


--
-- Name: namespace_statistics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_statistics (
    id integer NOT NULL,
    namespace_id integer NOT NULL,
    shared_runners_seconds integer DEFAULT 0 NOT NULL,
    shared_runners_seconds_last_reset timestamp without time zone
);


--
-- Name: namespace_statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_statistics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_statistics_id_seq OWNED BY public.namespace_statistics.id;


--
-- Name: namespaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespaces (
    id integer NOT NULL,
    name character varying NOT NULL,
    path character varying NOT NULL,
    owner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying,
    description character varying DEFAULT ''::character varying NOT NULL,
    avatar character varying,
    share_with_group_lock boolean DEFAULT false,
    visibility_level integer DEFAULT 20 NOT NULL,
    request_access_enabled boolean DEFAULT false NOT NULL,
    description_html text,
    lfs_enabled boolean,
    parent_id integer,
    require_two_factor_authentication boolean DEFAULT false NOT NULL,
    two_factor_grace_period integer DEFAULT 48 NOT NULL,
    cached_markdown_version integer,
    runners_token character varying,
    runners_token_encrypted character varying,
    project_creation_level integer,
    auto_devops_enabled boolean,
    last_ci_minutes_notification_at timestamp with time zone,
    custom_project_templates_group_id integer,
    file_template_project_id integer,
    ldap_sync_error character varying,
    ldap_sync_last_successful_update_at timestamp without time zone,
    ldap_sync_last_sync_at timestamp without time zone,
    ldap_sync_last_update_at timestamp without time zone,
    plan_id integer,
    repository_size_limit bigint,
    saml_discovery_token character varying,
    shared_runners_minutes_limit integer,
    trial_ends_on timestamp with time zone,
    extra_shared_runners_minutes_limit integer,
    ldap_sync_status character varying DEFAULT 'ready'::character varying NOT NULL,
    membership_lock boolean DEFAULT false,
    last_ci_minutes_usage_notification_level integer
);


--
-- Name: namespaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespaces_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespaces_id_seq OWNED BY public.namespaces.id;


--
-- Name: note_diff_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.note_diff_files (
    id integer NOT NULL,
    diff_note_id integer NOT NULL,
    diff text NOT NULL,
    new_file boolean NOT NULL,
    renamed_file boolean NOT NULL,
    deleted_file boolean NOT NULL,
    a_mode character varying NOT NULL,
    b_mode character varying NOT NULL,
    new_path text NOT NULL,
    old_path text NOT NULL
);


--
-- Name: note_diff_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.note_diff_files_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_diff_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.note_diff_files_id_seq OWNED BY public.note_diff_files.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id integer NOT NULL,
    note text,
    noteable_type character varying,
    author_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    project_id integer,
    attachment character varying,
    line_code character varying,
    commit_id character varying,
    noteable_id integer,
    system boolean DEFAULT false NOT NULL,
    st_diff text,
    updated_by_id integer,
    type character varying,
    "position" text,
    original_position text,
    resolved_at timestamp without time zone,
    resolved_by_id integer,
    discussion_id character varying,
    note_html text,
    cached_markdown_version integer,
    change_position text,
    resolved_by_push boolean,
    review_id bigint
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: notification_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notification_settings (
    id integer NOT NULL,
    user_id integer NOT NULL,
    source_id integer,
    source_type character varying,
    level integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    new_note boolean,
    new_issue boolean,
    reopen_issue boolean,
    close_issue boolean,
    reassign_issue boolean,
    new_merge_request boolean,
    reopen_merge_request boolean,
    close_merge_request boolean,
    reassign_merge_request boolean,
    merge_merge_request boolean,
    failed_pipeline boolean,
    success_pipeline boolean,
    push_to_merge_request boolean,
    issue_due boolean,
    notification_email character varying,
    new_epic boolean
);


--
-- Name: notification_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notification_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notification_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notification_settings_id_seq OWNED BY public.notification_settings.id;


--
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_grants (
    id integer NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id integer NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying
);


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_access_grants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_grants_id_seq OWNED BY public.oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_access_tokens (
    id integer NOT NULL,
    resource_owner_id integer,
    application_id integer,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying
);


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_access_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_access_tokens_id_seq OWNED BY public.oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_applications (
    id integer NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_id integer,
    owner_type character varying,
    trusted boolean DEFAULT false NOT NULL
);


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_applications_id_seq OWNED BY public.oauth_applications.id;


--
-- Name: oauth_openid_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oauth_openid_requests (
    id integer NOT NULL,
    access_grant_id integer NOT NULL,
    nonce character varying NOT NULL
);


--
-- Name: oauth_openid_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oauth_openid_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_openid_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oauth_openid_requests_id_seq OWNED BY public.oauth_openid_requests.id;


--
-- Name: operations_feature_flag_scopes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.operations_feature_flag_scopes (
    id bigint NOT NULL,
    feature_flag_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    active boolean NOT NULL,
    environment_scope character varying DEFAULT '*'::character varying NOT NULL,
    strategies jsonb DEFAULT '[{"name": "default", "parameters": {}}]'::jsonb NOT NULL
);


--
-- Name: operations_feature_flag_scopes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.operations_feature_flag_scopes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operations_feature_flag_scopes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.operations_feature_flag_scopes_id_seq OWNED BY public.operations_feature_flag_scopes.id;


--
-- Name: operations_feature_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.operations_feature_flags (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    active boolean NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying NOT NULL,
    description text
);


--
-- Name: operations_feature_flags_clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.operations_feature_flags_clients (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    token character varying,
    token_encrypted character varying
);


--
-- Name: operations_feature_flags_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.operations_feature_flags_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operations_feature_flags_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.operations_feature_flags_clients_id_seq OWNED BY public.operations_feature_flags_clients.id;


--
-- Name: operations_feature_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.operations_feature_flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operations_feature_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.operations_feature_flags_id_seq OWNED BY public.operations_feature_flags.id;


--
-- Name: packages_maven_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.packages_maven_metadata (
    id bigint NOT NULL,
    package_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    app_group character varying NOT NULL,
    app_name character varying NOT NULL,
    app_version character varying,
    path character varying(512) NOT NULL
);


--
-- Name: packages_maven_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.packages_maven_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packages_maven_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.packages_maven_metadata_id_seq OWNED BY public.packages_maven_metadata.id;


--
-- Name: packages_package_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.packages_package_files (
    id bigint NOT NULL,
    package_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    size bigint,
    file_type integer,
    file_store integer,
    file_md5 bytea,
    file_sha1 bytea,
    file_name character varying NOT NULL,
    file text NOT NULL
);


--
-- Name: packages_package_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.packages_package_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packages_package_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.packages_package_files_id_seq OWNED BY public.packages_package_files.id;


--
-- Name: packages_packages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.packages_packages (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying NOT NULL,
    version character varying,
    package_type smallint NOT NULL
);


--
-- Name: packages_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.packages_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: packages_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.packages_packages_id_seq OWNED BY public.packages_packages.id;


--
-- Name: pages_domain_acme_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages_domain_acme_orders (
    id bigint NOT NULL,
    pages_domain_id integer NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    url character varying NOT NULL,
    challenge_token character varying NOT NULL,
    challenge_file_content text NOT NULL,
    encrypted_private_key text NOT NULL,
    encrypted_private_key_iv text NOT NULL
);


--
-- Name: pages_domain_acme_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_domain_acme_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_domain_acme_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_domain_acme_orders_id_seq OWNED BY public.pages_domain_acme_orders.id;


--
-- Name: pages_domains; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pages_domains (
    id integer NOT NULL,
    project_id integer,
    certificate text,
    encrypted_key text,
    encrypted_key_iv character varying,
    encrypted_key_salt character varying,
    domain character varying,
    verified_at timestamp with time zone,
    verification_code character varying NOT NULL,
    enabled_until timestamp with time zone,
    remove_at timestamp with time zone,
    auto_ssl_enabled boolean DEFAULT false NOT NULL,
    certificate_valid_not_before timestamp with time zone,
    certificate_valid_not_after timestamp with time zone,
    certificate_source smallint DEFAULT 0 NOT NULL
);


--
-- Name: pages_domains_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pages_domains_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pages_domains_id_seq OWNED BY public.pages_domains.id;


--
-- Name: path_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.path_locks (
    id integer NOT NULL,
    path character varying NOT NULL,
    project_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: path_locks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.path_locks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: path_locks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.path_locks_id_seq OWNED BY public.path_locks.id;


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personal_access_tokens (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying NOT NULL,
    revoked boolean DEFAULT false,
    expires_at date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    scopes character varying DEFAULT '--- []
'::character varying NOT NULL,
    impersonation boolean DEFAULT false NOT NULL,
    token_digest character varying
);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plans (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    title character varying,
    active_pipelines_limit integer,
    pipeline_size_limit integer
);


--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: pool_repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_repositories (
    id bigint NOT NULL,
    shard_id integer NOT NULL,
    disk_path character varying,
    state character varying,
    source_project_id integer
);


--
-- Name: pool_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pool_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_repositories_id_seq OWNED BY public.pool_repositories.id;


--
-- Name: programming_languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.programming_languages (
    id integer NOT NULL,
    name character varying NOT NULL,
    color character varying NOT NULL,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: programming_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.programming_languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programming_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.programming_languages_id_seq OWNED BY public.programming_languages.id;


--
-- Name: project_alerting_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_alerting_settings (
    project_id integer NOT NULL,
    encrypted_token character varying NOT NULL,
    encrypted_token_iv character varying NOT NULL
);


--
-- Name: project_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_aliases (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: project_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_aliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_aliases_id_seq OWNED BY public.project_aliases.id;


--
-- Name: project_authorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_authorizations (
    user_id integer NOT NULL,
    project_id integer NOT NULL,
    access_level integer NOT NULL
);


--
-- Name: project_auto_devops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_auto_devops (
    id integer NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    enabled boolean,
    deploy_strategy integer DEFAULT 0 NOT NULL
);


--
-- Name: project_auto_devops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_auto_devops_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_auto_devops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_auto_devops_id_seq OWNED BY public.project_auto_devops.id;


--
-- Name: project_ci_cd_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_ci_cd_settings (
    id integer NOT NULL,
    project_id integer NOT NULL,
    group_runners_enabled boolean DEFAULT true NOT NULL,
    merge_pipelines_enabled boolean,
    merge_trains_enabled boolean DEFAULT false NOT NULL,
    default_git_depth integer
);


--
-- Name: project_ci_cd_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_ci_cd_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_ci_cd_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_ci_cd_settings_id_seq OWNED BY public.project_ci_cd_settings.id;


--
-- Name: project_custom_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_custom_attributes (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL
);


--
-- Name: project_custom_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_custom_attributes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_custom_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_custom_attributes_id_seq OWNED BY public.project_custom_attributes.id;


--
-- Name: project_daily_statistics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_daily_statistics (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    fetch_count integer NOT NULL,
    date date
);


--
-- Name: project_daily_statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_daily_statistics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_daily_statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_daily_statistics_id_seq OWNED BY public.project_daily_statistics.id;


--
-- Name: project_deploy_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_deploy_tokens (
    id integer NOT NULL,
    project_id integer NOT NULL,
    deploy_token_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: project_deploy_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_deploy_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_deploy_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_deploy_tokens_id_seq OWNED BY public.project_deploy_tokens.id;


--
-- Name: project_error_tracking_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_error_tracking_settings (
    project_id integer NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    api_url character varying,
    encrypted_token character varying,
    encrypted_token_iv character varying,
    project_name character varying,
    organization_name character varying
);


--
-- Name: project_feature_usages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_feature_usages (
    project_id integer NOT NULL,
    jira_dvcs_cloud_last_sync_at timestamp without time zone,
    jira_dvcs_server_last_sync_at timestamp without time zone
);


--
-- Name: project_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_features (
    id integer NOT NULL,
    project_id integer NOT NULL,
    merge_requests_access_level integer,
    issues_access_level integer,
    wiki_access_level integer,
    snippets_access_level integer DEFAULT 20 NOT NULL,
    builds_access_level integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    repository_access_level integer DEFAULT 20 NOT NULL,
    pages_access_level integer DEFAULT 20 NOT NULL
);


--
-- Name: project_features_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_features_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_features_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_features_id_seq OWNED BY public.project_features.id;


--
-- Name: project_group_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_group_links (
    id integer NOT NULL,
    project_id integer NOT NULL,
    group_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    group_access integer DEFAULT 30 NOT NULL,
    expires_at date
);


--
-- Name: project_group_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_group_links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_group_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_group_links_id_seq OWNED BY public.project_group_links.id;


--
-- Name: project_import_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_import_data (
    id integer NOT NULL,
    project_id integer,
    data text,
    encrypted_credentials text,
    encrypted_credentials_iv character varying,
    encrypted_credentials_salt character varying
);


--
-- Name: project_import_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_import_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_import_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_import_data_id_seq OWNED BY public.project_import_data.id;


--
-- Name: project_incident_management_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_incident_management_settings (
    project_id integer NOT NULL,
    create_issue boolean DEFAULT true NOT NULL,
    send_email boolean DEFAULT false NOT NULL,
    issue_template_key text
);


--
-- Name: project_incident_management_settings_project_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_incident_management_settings_project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_incident_management_settings_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_incident_management_settings_project_id_seq OWNED BY public.project_incident_management_settings.project_id;


--
-- Name: project_metrics_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_metrics_settings (
    project_id integer NOT NULL,
    external_dashboard_url character varying NOT NULL
);


--
-- Name: project_mirror_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_mirror_data (
    id integer NOT NULL,
    project_id integer NOT NULL,
    status character varying,
    jid character varying,
    last_error text,
    last_successful_update_at timestamp with time zone,
    last_update_at timestamp with time zone,
    last_update_scheduled_at timestamp without time zone,
    last_update_started_at timestamp without time zone,
    next_execution_timestamp timestamp without time zone,
    retry_count integer DEFAULT 0 NOT NULL
);


--
-- Name: project_mirror_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_mirror_data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_mirror_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_mirror_data_id_seq OWNED BY public.project_mirror_data.id;


--
-- Name: project_repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_repositories (
    id bigint NOT NULL,
    shard_id integer NOT NULL,
    disk_path character varying NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: project_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_repositories_id_seq OWNED BY public.project_repositories.id;


--
-- Name: project_repository_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_repository_states (
    id integer NOT NULL,
    project_id integer NOT NULL,
    repository_verification_checksum bytea,
    wiki_verification_checksum bytea,
    last_repository_verification_failure character varying,
    last_wiki_verification_failure character varying,
    repository_retry_at timestamp with time zone,
    wiki_retry_at timestamp with time zone,
    repository_retry_count integer,
    wiki_retry_count integer,
    last_repository_verification_ran_at timestamp with time zone,
    last_wiki_verification_ran_at timestamp with time zone
);


--
-- Name: project_repository_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_repository_states_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_repository_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_repository_states_id_seq OWNED BY public.project_repository_states.id;


--
-- Name: project_statistics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_statistics (
    id integer NOT NULL,
    project_id integer NOT NULL,
    namespace_id integer NOT NULL,
    commit_count bigint DEFAULT 0 NOT NULL,
    storage_size bigint DEFAULT 0 NOT NULL,
    repository_size bigint DEFAULT 0 NOT NULL,
    lfs_objects_size bigint DEFAULT 0 NOT NULL,
    build_artifacts_size bigint DEFAULT 0 NOT NULL,
    packages_size bigint DEFAULT 0 NOT NULL,
    wiki_size bigint,
    shared_runners_seconds bigint DEFAULT 0 NOT NULL,
    shared_runners_seconds_last_reset timestamp without time zone
);


--
-- Name: project_statistics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_statistics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_statistics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_statistics_id_seq OWNED BY public.project_statistics.id;


--
-- Name: project_tracing_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_tracing_settings (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer NOT NULL,
    external_url character varying NOT NULL
);


--
-- Name: project_tracing_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_tracing_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_tracing_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_tracing_settings_id_seq OWNED BY public.project_tracing_settings.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name character varying,
    path character varying,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    creator_id integer,
    namespace_id integer NOT NULL,
    last_activity_at timestamp without time zone,
    import_url character varying,
    visibility_level integer DEFAULT 0 NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    avatar character varying,
    star_count integer DEFAULT 0 NOT NULL,
    import_type character varying,
    import_source character varying,
    shared_runners_enabled boolean DEFAULT true NOT NULL,
    runners_token character varying,
    build_coverage_regex character varying,
    build_allow_git_fetch boolean DEFAULT true NOT NULL,
    build_timeout integer DEFAULT 3600 NOT NULL,
    pending_delete boolean DEFAULT false,
    public_builds boolean DEFAULT true NOT NULL,
    last_repository_check_failed boolean,
    last_repository_check_at timestamp without time zone,
    container_registry_enabled boolean,
    only_allow_merge_if_pipeline_succeeds boolean DEFAULT false NOT NULL,
    has_external_issue_tracker boolean,
    repository_storage character varying DEFAULT 'default'::character varying NOT NULL,
    request_access_enabled boolean DEFAULT false NOT NULL,
    has_external_wiki boolean,
    ci_config_path character varying,
    lfs_enabled boolean,
    description_html text,
    only_allow_merge_if_all_discussions_are_resolved boolean,
    printing_merge_request_link_enabled boolean DEFAULT true NOT NULL,
    auto_cancel_pending_pipelines integer DEFAULT 1 NOT NULL,
    cached_markdown_version integer,
    delete_error text,
    last_repository_updated_at timestamp without time zone,
    storage_version smallint,
    resolve_outdated_diff_discussions boolean,
    repository_read_only boolean,
    merge_requests_ff_only_enabled boolean DEFAULT false,
    merge_requests_rebase_enabled boolean DEFAULT false,
    jobs_cache_index integer,
    pages_https_only boolean DEFAULT true,
    remote_mirror_available_overridden boolean,
    pool_repository_id bigint,
    runners_token_encrypted character varying,
    bfg_object_map character varying,
    detected_repository_languages boolean,
    external_authorization_classification_label character varying,
    disable_overriding_approvers_per_merge_request boolean,
    external_webhook_token character varying,
    issues_template text,
    merge_requests_author_approval boolean,
    merge_requests_disable_committers_approval boolean,
    merge_requests_require_code_owner_approval boolean,
    merge_requests_template text,
    mirror_last_successful_update_at timestamp without time zone,
    mirror_last_update_at timestamp without time zone,
    mirror_overwrites_diverged_branches boolean,
    mirror_user_id integer,
    only_mirror_protected_branches boolean,
    packages_enabled boolean,
    pull_mirror_available_overridden boolean,
    repository_size_limit bigint,
    require_password_to_approve boolean,
    mirror boolean DEFAULT false NOT NULL,
    mirror_trigger_builds boolean DEFAULT false NOT NULL,
    reset_approvals_on_push boolean DEFAULT true,
    service_desk_enabled boolean DEFAULT true,
    approvals_before_merge integer DEFAULT 0 NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: prometheus_alert_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prometheus_alert_events (
    id bigint NOT NULL,
    project_id integer NOT NULL,
    prometheus_alert_id integer NOT NULL,
    started_at timestamp with time zone NOT NULL,
    ended_at timestamp with time zone,
    status smallint,
    payload_key character varying
);


--
-- Name: prometheus_alert_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prometheus_alert_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prometheus_alert_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prometheus_alert_events_id_seq OWNED BY public.prometheus_alert_events.id;


--
-- Name: prometheus_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prometheus_alerts (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    threshold double precision NOT NULL,
    operator integer NOT NULL,
    environment_id integer NOT NULL,
    project_id integer NOT NULL,
    prometheus_metric_id integer NOT NULL
);


--
-- Name: prometheus_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prometheus_alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prometheus_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prometheus_alerts_id_seq OWNED BY public.prometheus_alerts.id;


--
-- Name: prometheus_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prometheus_metrics (
    id integer NOT NULL,
    project_id integer,
    title character varying NOT NULL,
    query character varying NOT NULL,
    y_label character varying,
    unit character varying,
    legend character varying,
    "group" integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    common boolean DEFAULT false NOT NULL,
    identifier character varying
);


--
-- Name: prometheus_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prometheus_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prometheus_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prometheus_metrics_id_seq OWNED BY public.prometheus_metrics.id;


--
-- Name: protected_branch_merge_access_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_branch_merge_access_levels (
    id integer NOT NULL,
    protected_branch_id integer NOT NULL,
    access_level integer DEFAULT 40,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    group_id integer,
    user_id integer
);


--
-- Name: protected_branch_merge_access_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_branch_merge_access_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_branch_merge_access_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_branch_merge_access_levels_id_seq OWNED BY public.protected_branch_merge_access_levels.id;


--
-- Name: protected_branch_push_access_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_branch_push_access_levels (
    id integer NOT NULL,
    protected_branch_id integer NOT NULL,
    access_level integer DEFAULT 40,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    group_id integer,
    user_id integer
);


--
-- Name: protected_branch_push_access_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_branch_push_access_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_branch_push_access_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_branch_push_access_levels_id_seq OWNED BY public.protected_branch_push_access_levels.id;


--
-- Name: protected_branch_unprotect_access_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_branch_unprotect_access_levels (
    id integer NOT NULL,
    protected_branch_id integer NOT NULL,
    access_level integer DEFAULT 40,
    user_id integer,
    group_id integer
);


--
-- Name: protected_branch_unprotect_access_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_branch_unprotect_access_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_branch_unprotect_access_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_branch_unprotect_access_levels_id_seq OWNED BY public.protected_branch_unprotect_access_levels.id;


--
-- Name: protected_branches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_branches (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: protected_branches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_branches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_branches_id_seq OWNED BY public.protected_branches.id;


--
-- Name: protected_environment_deploy_access_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_environment_deploy_access_levels (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    access_level integer DEFAULT 40,
    protected_environment_id integer NOT NULL,
    user_id integer,
    group_id integer
);


--
-- Name: protected_environment_deploy_access_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_environment_deploy_access_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_environment_deploy_access_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_environment_deploy_access_levels_id_seq OWNED BY public.protected_environment_deploy_access_levels.id;


--
-- Name: protected_environments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_environments (
    id integer NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    name character varying NOT NULL
);


--
-- Name: protected_environments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_environments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_environments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_environments_id_seq OWNED BY public.protected_environments.id;


--
-- Name: protected_tag_create_access_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_tag_create_access_levels (
    id integer NOT NULL,
    protected_tag_id integer NOT NULL,
    access_level integer DEFAULT 40,
    user_id integer,
    group_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: protected_tag_create_access_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_tag_create_access_levels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_tag_create_access_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_tag_create_access_levels_id_seq OWNED BY public.protected_tag_create_access_levels.id;


--
-- Name: protected_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.protected_tags (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: protected_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.protected_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.protected_tags_id_seq OWNED BY public.protected_tags.id;


--
-- Name: push_event_payloads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.push_event_payloads (
    commit_count bigint NOT NULL,
    event_id integer NOT NULL,
    action smallint NOT NULL,
    ref_type smallint NOT NULL,
    commit_from bytea,
    commit_to bytea,
    ref text,
    commit_title character varying(70)
);


--
-- Name: push_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.push_rules (
    id integer NOT NULL,
    force_push_regex character varying,
    delete_branch_regex character varying,
    commit_message_regex character varying,
    deny_delete_tag boolean,
    project_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    author_email_regex character varying,
    member_check boolean DEFAULT false NOT NULL,
    file_name_regex character varying,
    is_sample boolean DEFAULT false,
    max_file_size integer DEFAULT 0 NOT NULL,
    prevent_secrets boolean DEFAULT false NOT NULL,
    branch_name_regex character varying,
    reject_unsigned_commits boolean,
    commit_committer_check boolean,
    regexp_uses_re2 boolean DEFAULT true,
    commit_message_negative_regex character varying
);


--
-- Name: push_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.push_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: push_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.push_rules_id_seq OWNED BY public.push_rules.id;


--
-- Name: redirect_routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.redirect_routes (
    id integer NOT NULL,
    source_id integer NOT NULL,
    source_type character varying NOT NULL,
    path character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: redirect_routes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.redirect_routes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: redirect_routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.redirect_routes_id_seq OWNED BY public.redirect_routes.id;


--
-- Name: release_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.release_links (
    id bigint NOT NULL,
    release_id integer NOT NULL,
    url character varying NOT NULL,
    name character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: release_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.release_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: release_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.release_links_id_seq OWNED BY public.release_links.id;


--
-- Name: releases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.releases (
    id integer NOT NULL,
    tag character varying,
    description text,
    project_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description_html text,
    cached_markdown_version integer,
    author_id integer,
    name character varying,
    sha character varying,
    released_at timestamp with time zone NOT NULL
);


--
-- Name: releases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.releases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: releases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.releases_id_seq OWNED BY public.releases.id;


--
-- Name: remote_mirrors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.remote_mirrors (
    id integer NOT NULL,
    project_id integer,
    url character varying,
    enabled boolean DEFAULT false,
    update_status character varying,
    last_update_at timestamp without time zone,
    last_successful_update_at timestamp without time zone,
    last_update_started_at timestamp without time zone,
    last_error character varying,
    only_protected_branches boolean DEFAULT false NOT NULL,
    remote_name character varying,
    encrypted_credentials text,
    encrypted_credentials_iv character varying,
    encrypted_credentials_salt character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    error_notification_sent boolean
);


--
-- Name: remote_mirrors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.remote_mirrors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: remote_mirrors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.remote_mirrors_id_seq OWNED BY public.remote_mirrors.id;


--
-- Name: repository_languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repository_languages (
    project_id integer NOT NULL,
    programming_language_id integer NOT NULL,
    share double precision NOT NULL
);


--
-- Name: resource_label_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resource_label_events (
    id bigint NOT NULL,
    action integer NOT NULL,
    issue_id integer,
    merge_request_id integer,
    label_id integer,
    user_id integer,
    created_at timestamp with time zone NOT NULL,
    cached_markdown_version integer,
    reference text,
    reference_html text,
    epic_id integer
);


--
-- Name: resource_label_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.resource_label_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_label_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.resource_label_events_id_seq OWNED BY public.resource_label_events.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    author_id integer,
    merge_request_id integer NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.routes (
    id integer NOT NULL,
    source_id integer NOT NULL,
    source_type character varying NOT NULL,
    path character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying
);


--
-- Name: routes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.routes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.routes_id_seq OWNED BY public.routes.id;


--
-- Name: saml_providers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.saml_providers (
    id integer NOT NULL,
    group_id integer NOT NULL,
    enabled boolean NOT NULL,
    certificate_fingerprint character varying NOT NULL,
    sso_url character varying NOT NULL,
    enforced_sso boolean DEFAULT false NOT NULL,
    enforced_group_managed_accounts boolean DEFAULT false NOT NULL
);


--
-- Name: saml_providers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.saml_providers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: saml_providers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.saml_providers_id_seq OWNED BY public.saml_providers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: scim_oauth_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scim_oauth_access_tokens (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    group_id integer NOT NULL,
    token_encrypted character varying NOT NULL
);


--
-- Name: scim_oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scim_oauth_access_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scim_oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scim_oauth_access_tokens_id_seq OWNED BY public.scim_oauth_access_tokens.id;


--
-- Name: sent_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sent_notifications (
    id integer NOT NULL,
    project_id integer,
    noteable_id integer,
    noteable_type character varying,
    recipient_id integer,
    commit_id character varying,
    reply_key character varying NOT NULL,
    line_code character varying,
    note_type character varying,
    "position" text,
    in_reply_to_discussion_id character varying
);


--
-- Name: sent_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sent_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sent_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sent_notifications_id_seq OWNED BY public.sent_notifications.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    id integer NOT NULL,
    type character varying,
    title character varying,
    project_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    active boolean DEFAULT false NOT NULL,
    properties text,
    template boolean DEFAULT false,
    push_events boolean DEFAULT true,
    issues_events boolean DEFAULT true,
    merge_requests_events boolean DEFAULT true,
    tag_push_events boolean DEFAULT true,
    note_events boolean DEFAULT true NOT NULL,
    category character varying DEFAULT 'common'::character varying NOT NULL,
    "default" boolean DEFAULT false,
    wiki_page_events boolean DEFAULT true,
    pipeline_events boolean DEFAULT false NOT NULL,
    confidential_issues_events boolean DEFAULT true NOT NULL,
    commit_events boolean DEFAULT true NOT NULL,
    job_events boolean DEFAULT false NOT NULL,
    confidential_note_events boolean DEFAULT true,
    deployment_events boolean DEFAULT false NOT NULL,
    description character varying(500)
);


--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: shards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shards (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: shards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shards_id_seq OWNED BY public.shards.id;


--
-- Name: slack_integrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.slack_integrations (
    id integer NOT NULL,
    service_id integer NOT NULL,
    team_id character varying NOT NULL,
    team_name character varying NOT NULL,
    alias character varying NOT NULL,
    user_id character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: slack_integrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.slack_integrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slack_integrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.slack_integrations_id_seq OWNED BY public.slack_integrations.id;


--
-- Name: smartcard_identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.smartcard_identities (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    subject character varying NOT NULL,
    issuer character varying NOT NULL
);


--
-- Name: smartcard_identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.smartcard_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: smartcard_identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.smartcard_identities_id_seq OWNED BY public.smartcard_identities.id;


--
-- Name: snippets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.snippets (
    id integer NOT NULL,
    title character varying,
    content text,
    author_id integer NOT NULL,
    project_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    file_name character varying,
    type character varying,
    visibility_level integer DEFAULT 0 NOT NULL,
    title_html text,
    content_html text,
    cached_markdown_version integer,
    description text,
    description_html text
);


--
-- Name: snippets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.snippets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snippets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.snippets_id_seq OWNED BY public.snippets.id;


--
-- Name: software_license_policies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.software_license_policies (
    id integer NOT NULL,
    project_id integer NOT NULL,
    software_license_id integer NOT NULL,
    approval_status integer DEFAULT 0 NOT NULL
);


--
-- Name: software_license_policies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.software_license_policies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: software_license_policies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.software_license_policies_id_seq OWNED BY public.software_license_policies.id;


--
-- Name: software_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.software_licenses (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: software_licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.software_licenses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: software_licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.software_licenses_id_seq OWNED BY public.software_licenses.id;


--
-- Name: spam_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spam_logs (
    id integer NOT NULL,
    user_id integer,
    source_ip character varying,
    user_agent character varying,
    via_api boolean,
    noteable_type character varying,
    title character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    submitted_as_ham boolean DEFAULT false NOT NULL,
    recaptcha_verified boolean DEFAULT false NOT NULL
);


--
-- Name: spam_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spam_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spam_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spam_logs_id_seq OWNED BY public.spam_logs.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    user_id integer,
    subscribable_id integer,
    subscribable_type character varying,
    subscribed boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    project_id integer
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: suggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suggestions (
    id bigint NOT NULL,
    note_id integer NOT NULL,
    relative_order smallint NOT NULL,
    applied boolean DEFAULT false NOT NULL,
    commit_id character varying,
    from_content text NOT NULL,
    to_content text NOT NULL,
    lines_above integer DEFAULT 0 NOT NULL,
    lines_below integer DEFAULT 0 NOT NULL,
    outdated boolean DEFAULT false NOT NULL
);


--
-- Name: suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.suggestions_id_seq OWNED BY public.suggestions.id;


--
-- Name: system_note_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.system_note_metadata (
    id integer NOT NULL,
    note_id integer NOT NULL,
    commit_count integer,
    action character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: system_note_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.system_note_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: system_note_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.system_note_metadata_id_seq OWNED BY public.system_note_metadata.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying,
    tagger_id integer,
    tagger_type character varying,
    context character varying,
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggings_id_seq OWNED BY public.taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    name character varying,
    taggings_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: term_agreements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.term_agreements (
    id integer NOT NULL,
    term_id integer NOT NULL,
    user_id integer NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: term_agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.term_agreements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: term_agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.term_agreements_id_seq OWNED BY public.term_agreements.id;


--
-- Name: timelogs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timelogs (
    id integer NOT NULL,
    time_spent integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    issue_id integer,
    merge_request_id integer,
    spent_at timestamp with time zone
);


--
-- Name: timelogs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timelogs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timelogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timelogs_id_seq OWNED BY public.timelogs.id;


--
-- Name: todos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.todos (
    id integer NOT NULL,
    user_id integer NOT NULL,
    project_id integer,
    target_id integer,
    target_type character varying NOT NULL,
    author_id integer NOT NULL,
    action integer NOT NULL,
    state character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    note_id integer,
    commit_id character varying,
    group_id integer
);


--
-- Name: todos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.todos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: todos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.todos_id_seq OWNED BY public.todos.id;


--
-- Name: trending_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trending_projects (
    id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: trending_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trending_projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trending_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trending_projects_id_seq OWNED BY public.trending_projects.id;


--
-- Name: u2f_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.u2f_registrations (
    id integer NOT NULL,
    certificate text,
    key_handle character varying,
    public_key character varying,
    counter integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: u2f_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.u2f_registrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: u2f_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.u2f_registrations_id_seq OWNED BY public.u2f_registrations.id;


--
-- Name: uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.uploads (
    id integer NOT NULL,
    size bigint NOT NULL,
    path character varying(511) NOT NULL,
    checksum character varying(64),
    model_id integer,
    model_type character varying,
    uploader character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    mount_point character varying,
    secret character varying,
    store integer
);


--
-- Name: uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.uploads_id_seq OWNED BY public.uploads.id;


--
-- Name: user_agent_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_agent_details (
    id integer NOT NULL,
    user_agent character varying NOT NULL,
    ip_address character varying NOT NULL,
    subject_id integer NOT NULL,
    subject_type character varying NOT NULL,
    submitted boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_agent_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_agent_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_agent_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_agent_details_id_seq OWNED BY public.user_agent_details.id;


--
-- Name: user_callouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_callouts (
    id integer NOT NULL,
    feature_name integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: user_callouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_callouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_callouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_callouts_id_seq OWNED BY public.user_callouts.id;


--
-- Name: user_custom_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_custom_attributes (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    key character varying NOT NULL,
    value character varying NOT NULL
);


--
-- Name: user_custom_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_custom_attributes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_custom_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_custom_attributes_id_seq OWNED BY public.user_custom_attributes.id;


--
-- Name: user_interacted_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_interacted_projects (
    user_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: user_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_preferences (
    id integer NOT NULL,
    user_id integer NOT NULL,
    issue_notes_filter smallint DEFAULT 0 NOT NULL,
    merge_request_notes_filter smallint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    first_day_of_week integer,
    issues_sort character varying,
    merge_requests_sort character varying,
    timezone character varying,
    time_display_relative boolean,
    time_format_in_24h boolean,
    epic_notes_filter smallint DEFAULT 0 NOT NULL,
    epics_sort character varying,
    roadmap_epics_state integer,
    roadmaps_sort character varying
);


--
-- Name: user_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_preferences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_preferences_id_seq OWNED BY public.user_preferences.id;


--
-- Name: user_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_statuses (
    user_id integer NOT NULL,
    cached_markdown_version integer,
    emoji character varying DEFAULT 'speech_balloon'::character varying NOT NULL,
    message character varying(100),
    message_html character varying
);


--
-- Name: user_statuses_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_statuses_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_statuses_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_statuses_user_id_seq OWNED BY public.user_statuses.user_id;


--
-- Name: user_synced_attributes_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_synced_attributes_metadata (
    id integer NOT NULL,
    name_synced boolean DEFAULT false,
    email_synced boolean DEFAULT false,
    location_synced boolean DEFAULT false,
    user_id integer NOT NULL,
    provider character varying
);


--
-- Name: user_synced_attributes_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_synced_attributes_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_synced_attributes_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_synced_attributes_metadata_id_seq OWNED BY public.user_synced_attributes_metadata.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying,
    admin boolean DEFAULT false NOT NULL,
    projects_limit integer NOT NULL,
    skype character varying DEFAULT ''::character varying NOT NULL,
    linkedin character varying DEFAULT ''::character varying NOT NULL,
    twitter character varying DEFAULT ''::character varying NOT NULL,
    bio character varying,
    failed_attempts integer DEFAULT 0,
    locked_at timestamp without time zone,
    username character varying,
    can_create_group boolean DEFAULT true NOT NULL,
    can_create_team boolean DEFAULT true NOT NULL,
    state character varying,
    color_scheme_id integer DEFAULT 1 NOT NULL,
    password_expires_at timestamp without time zone,
    created_by_id integer,
    last_credential_check_at timestamp without time zone,
    avatar character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    hide_no_ssh_key boolean DEFAULT false,
    website_url character varying DEFAULT ''::character varying NOT NULL,
    notification_email character varying,
    hide_no_password boolean DEFAULT false,
    password_automatically_set boolean DEFAULT false,
    location character varying,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    encrypted_otp_secret_salt character varying,
    otp_required_for_login boolean DEFAULT false NOT NULL,
    otp_backup_codes text,
    public_email character varying DEFAULT ''::character varying NOT NULL,
    dashboard integer DEFAULT 0,
    project_view integer DEFAULT 0,
    consumed_timestep integer,
    layout integer DEFAULT 0,
    hide_project_limit boolean DEFAULT false,
    unlock_token character varying,
    otp_grace_period_started_at timestamp without time zone,
    external boolean DEFAULT false,
    incoming_email_token character varying,
    organization character varying,
    require_two_factor_authentication_from_group boolean DEFAULT false NOT NULL,
    two_factor_grace_period integer DEFAULT 48 NOT NULL,
    ghost boolean,
    last_activity_on date,
    notified_of_own_activity boolean,
    preferred_language character varying,
    theme_id smallint,
    accepted_term_id integer,
    feed_token character varying,
    private_profile boolean,
    include_private_contributions boolean,
    commit_email character varying,
    auditor boolean DEFAULT false NOT NULL,
    admin_email_unsubscribed_at timestamp without time zone,
    email_opted_in boolean,
    email_opted_in_at timestamp without time zone,
    email_opted_in_ip character varying,
    email_opted_in_source_id integer,
    group_view integer,
    managing_group_id integer,
    note text,
    roadmap_layout smallint,
    bot_type smallint
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_ops_dashboard_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_ops_dashboard_projects (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    project_id integer NOT NULL
);


--
-- Name: users_ops_dashboard_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_ops_dashboard_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_ops_dashboard_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_ops_dashboard_projects_id_seq OWNED BY public.users_ops_dashboard_projects.id;


--
-- Name: users_star_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_star_projects (
    id integer NOT NULL,
    project_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_star_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_star_projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_star_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_star_projects_id_seq OWNED BY public.users_star_projects.id;


--
-- Name: vulnerability_feedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_feedback (
    id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    feedback_type smallint NOT NULL,
    category smallint NOT NULL,
    project_id integer NOT NULL,
    author_id integer NOT NULL,
    pipeline_id integer,
    issue_id integer,
    project_fingerprint character varying(40) NOT NULL,
    merge_request_id integer,
    comment_author_id integer,
    comment text,
    comment_timestamp timestamp with time zone
);


--
-- Name: vulnerability_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_feedback_id_seq OWNED BY public.vulnerability_feedback.id;


--
-- Name: vulnerability_identifiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_identifiers (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer NOT NULL,
    fingerprint bytea NOT NULL,
    external_type character varying NOT NULL,
    external_id character varying NOT NULL,
    name character varying NOT NULL,
    url text
);


--
-- Name: vulnerability_identifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_identifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_identifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_identifiers_id_seq OWNED BY public.vulnerability_identifiers.id;


--
-- Name: vulnerability_occurrence_identifiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_occurrence_identifiers (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    occurrence_id bigint NOT NULL,
    identifier_id bigint NOT NULL
);


--
-- Name: vulnerability_occurrence_identifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_occurrence_identifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_occurrence_identifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_occurrence_identifiers_id_seq OWNED BY public.vulnerability_occurrence_identifiers.id;


--
-- Name: vulnerability_occurrence_pipelines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_occurrence_pipelines (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    occurrence_id bigint NOT NULL,
    pipeline_id integer NOT NULL
);


--
-- Name: vulnerability_occurrence_pipelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_occurrence_pipelines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_occurrence_pipelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_occurrence_pipelines_id_seq OWNED BY public.vulnerability_occurrence_pipelines.id;


--
-- Name: vulnerability_occurrences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_occurrences (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    severity smallint NOT NULL,
    confidence smallint NOT NULL,
    report_type smallint NOT NULL,
    project_id integer NOT NULL,
    scanner_id bigint NOT NULL,
    primary_identifier_id bigint NOT NULL,
    project_fingerprint bytea NOT NULL,
    location_fingerprint bytea NOT NULL,
    uuid character varying(36) NOT NULL,
    name character varying NOT NULL,
    metadata_version character varying NOT NULL,
    raw_metadata text NOT NULL
);


--
-- Name: vulnerability_occurrences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_occurrences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_occurrences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_occurrences_id_seq OWNED BY public.vulnerability_occurrences.id;


--
-- Name: vulnerability_scanners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vulnerability_scanners (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    project_id integer NOT NULL,
    external_id character varying NOT NULL,
    name character varying NOT NULL
);


--
-- Name: vulnerability_scanners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vulnerability_scanners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vulnerability_scanners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vulnerability_scanners_id_seq OWNED BY public.vulnerability_scanners.id;


--
-- Name: web_hook_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_hook_logs (
    id integer NOT NULL,
    web_hook_id integer NOT NULL,
    trigger character varying,
    url character varying,
    request_headers text,
    request_data text,
    response_headers text,
    response_body text,
    response_status character varying,
    execution_duration double precision,
    internal_error_message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: web_hook_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_hook_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_hook_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_hook_logs_id_seq OWNED BY public.web_hook_logs.id;


--
-- Name: web_hooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.web_hooks (
    id integer NOT NULL,
    project_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying DEFAULT 'ProjectHook'::character varying,
    service_id integer,
    push_events boolean DEFAULT true NOT NULL,
    issues_events boolean DEFAULT false NOT NULL,
    merge_requests_events boolean DEFAULT false NOT NULL,
    tag_push_events boolean DEFAULT false,
    note_events boolean DEFAULT false NOT NULL,
    enable_ssl_verification boolean DEFAULT true,
    wiki_page_events boolean DEFAULT false NOT NULL,
    pipeline_events boolean DEFAULT false NOT NULL,
    confidential_issues_events boolean DEFAULT false NOT NULL,
    repository_update_events boolean DEFAULT false NOT NULL,
    job_events boolean DEFAULT false NOT NULL,
    confidential_note_events boolean,
    push_events_branch_filter text,
    encrypted_token character varying,
    encrypted_token_iv character varying,
    encrypted_url character varying,
    encrypted_url_iv character varying,
    group_id integer
);


--
-- Name: web_hooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.web_hooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: web_hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.web_hooks_id_seq OWNED BY public.web_hooks.id;


--
-- Name: abuse_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.abuse_reports ALTER COLUMN id SET DEFAULT nextval('public.abuse_reports_id_seq'::regclass);


--
-- Name: appearances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appearances ALTER COLUMN id SET DEFAULT nextval('public.appearances_id_seq'::regclass);


--
-- Name: application_setting_terms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_setting_terms ALTER COLUMN id SET DEFAULT nextval('public.application_setting_terms_id_seq'::regclass);


--
-- Name: application_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings ALTER COLUMN id SET DEFAULT nextval('public.application_settings_id_seq'::regclass);


--
-- Name: approval_merge_request_rule_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rule_sources ALTER COLUMN id SET DEFAULT nextval('public.approval_merge_request_rule_sources_id_seq'::regclass);


--
-- Name: approval_merge_request_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules ALTER COLUMN id SET DEFAULT nextval('public.approval_merge_request_rules_id_seq'::regclass);


--
-- Name: approval_merge_request_rules_approved_approvers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_approved_approvers ALTER COLUMN id SET DEFAULT nextval('public.approval_merge_request_rules_approved_approvers_id_seq'::regclass);


--
-- Name: approval_merge_request_rules_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_groups ALTER COLUMN id SET DEFAULT nextval('public.approval_merge_request_rules_groups_id_seq'::regclass);


--
-- Name: approval_merge_request_rules_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_users ALTER COLUMN id SET DEFAULT nextval('public.approval_merge_request_rules_users_id_seq'::regclass);


--
-- Name: approval_project_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules ALTER COLUMN id SET DEFAULT nextval('public.approval_project_rules_id_seq'::regclass);


--
-- Name: approval_project_rules_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules_groups ALTER COLUMN id SET DEFAULT nextval('public.approval_project_rules_groups_id_seq'::regclass);


--
-- Name: approval_project_rules_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules_users ALTER COLUMN id SET DEFAULT nextval('public.approval_project_rules_users_id_seq'::regclass);


--
-- Name: approvals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approvals ALTER COLUMN id SET DEFAULT nextval('public.approvals_id_seq'::regclass);


--
-- Name: approver_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_groups ALTER COLUMN id SET DEFAULT nextval('public.approver_groups_id_seq'::regclass);


--
-- Name: approvers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approvers ALTER COLUMN id SET DEFAULT nextval('public.approvers_id_seq'::regclass);


--
-- Name: audit_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events ALTER COLUMN id SET DEFAULT nextval('public.audit_events_id_seq'::regclass);


--
-- Name: award_emoji id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.award_emoji ALTER COLUMN id SET DEFAULT nextval('public.award_emoji_id_seq'::regclass);


--
-- Name: badges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges ALTER COLUMN id SET DEFAULT nextval('public.badges_id_seq'::regclass);


--
-- Name: board_assignees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_assignees ALTER COLUMN id SET DEFAULT nextval('public.board_assignees_id_seq'::regclass);


--
-- Name: board_group_recent_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_group_recent_visits ALTER COLUMN id SET DEFAULT nextval('public.board_group_recent_visits_id_seq'::regclass);


--
-- Name: board_labels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_labels ALTER COLUMN id SET DEFAULT nextval('public.board_labels_id_seq'::regclass);


--
-- Name: board_project_recent_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_project_recent_visits ALTER COLUMN id SET DEFAULT nextval('public.board_project_recent_visits_id_seq'::regclass);


--
-- Name: boards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards ALTER COLUMN id SET DEFAULT nextval('public.boards_id_seq'::regclass);


--
-- Name: broadcast_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broadcast_messages ALTER COLUMN id SET DEFAULT nextval('public.broadcast_messages_id_seq'::regclass);


--
-- Name: chat_names id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_names ALTER COLUMN id SET DEFAULT nextval('public.chat_names_id_seq'::regclass);


--
-- Name: chat_teams id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_teams ALTER COLUMN id SET DEFAULT nextval('public.chat_teams_id_seq'::regclass);


--
-- Name: ci_build_trace_chunks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_chunks ALTER COLUMN id SET DEFAULT nextval('public.ci_build_trace_chunks_id_seq'::regclass);


--
-- Name: ci_build_trace_section_names id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_section_names ALTER COLUMN id SET DEFAULT nextval('public.ci_build_trace_section_names_id_seq'::regclass);


--
-- Name: ci_build_trace_sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_sections ALTER COLUMN id SET DEFAULT nextval('public.ci_build_trace_sections_id_seq'::regclass);


--
-- Name: ci_builds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds ALTER COLUMN id SET DEFAULT nextval('public.ci_builds_id_seq'::regclass);


--
-- Name: ci_builds_metadata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds_metadata ALTER COLUMN id SET DEFAULT nextval('public.ci_builds_metadata_id_seq'::regclass);


--
-- Name: ci_builds_runner_session id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds_runner_session ALTER COLUMN id SET DEFAULT nextval('public.ci_builds_runner_session_id_seq'::regclass);


--
-- Name: ci_group_variables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_group_variables ALTER COLUMN id SET DEFAULT nextval('public.ci_group_variables_id_seq'::regclass);


--
-- Name: ci_job_artifacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_job_artifacts ALTER COLUMN id SET DEFAULT nextval('public.ci_job_artifacts_id_seq'::regclass);


--
-- Name: ci_pipeline_chat_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_chat_data ALTER COLUMN id SET DEFAULT nextval('public.ci_pipeline_chat_data_id_seq'::regclass);


--
-- Name: ci_pipeline_schedule_variables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_schedule_variables ALTER COLUMN id SET DEFAULT nextval('public.ci_pipeline_schedule_variables_id_seq'::regclass);


--
-- Name: ci_pipeline_schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_schedules ALTER COLUMN id SET DEFAULT nextval('public.ci_pipeline_schedules_id_seq'::regclass);


--
-- Name: ci_pipeline_variables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_variables ALTER COLUMN id SET DEFAULT nextval('public.ci_pipeline_variables_id_seq'::regclass);


--
-- Name: ci_pipelines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipelines ALTER COLUMN id SET DEFAULT nextval('public.ci_pipelines_id_seq'::regclass);


--
-- Name: ci_runner_namespaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runner_namespaces ALTER COLUMN id SET DEFAULT nextval('public.ci_runner_namespaces_id_seq'::regclass);


--
-- Name: ci_runner_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runner_projects ALTER COLUMN id SET DEFAULT nextval('public.ci_runner_projects_id_seq'::regclass);


--
-- Name: ci_runners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runners ALTER COLUMN id SET DEFAULT nextval('public.ci_runners_id_seq'::regclass);


--
-- Name: ci_sources_pipelines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_sources_pipelines ALTER COLUMN id SET DEFAULT nextval('public.ci_sources_pipelines_id_seq'::regclass);


--
-- Name: ci_stages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_stages ALTER COLUMN id SET DEFAULT nextval('public.ci_stages_id_seq'::regclass);


--
-- Name: ci_trigger_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_trigger_requests ALTER COLUMN id SET DEFAULT nextval('public.ci_trigger_requests_id_seq'::regclass);


--
-- Name: ci_triggers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_triggers ALTER COLUMN id SET DEFAULT nextval('public.ci_triggers_id_seq'::regclass);


--
-- Name: ci_variables id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_variables ALTER COLUMN id SET DEFAULT nextval('public.ci_variables_id_seq'::regclass);


--
-- Name: cluster_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_groups ALTER COLUMN id SET DEFAULT nextval('public.cluster_groups_id_seq'::regclass);


--
-- Name: cluster_platforms_kubernetes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_platforms_kubernetes ALTER COLUMN id SET DEFAULT nextval('public.cluster_platforms_kubernetes_id_seq'::regclass);


--
-- Name: cluster_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_projects ALTER COLUMN id SET DEFAULT nextval('public.cluster_projects_id_seq'::regclass);


--
-- Name: cluster_providers_gcp id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_providers_gcp ALTER COLUMN id SET DEFAULT nextval('public.cluster_providers_gcp_id_seq'::regclass);


--
-- Name: clusters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters ALTER COLUMN id SET DEFAULT nextval('public.clusters_id_seq'::regclass);


--
-- Name: clusters_applications_cert_managers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_cert_managers ALTER COLUMN id SET DEFAULT nextval('public.clusters_applications_cert_managers_id_seq'::regclass);


--
-- Name: clusters_applications_helm id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_helm ALTER COLUMN id SET DEFAULT nextval('public.clusters_applications_helm_id_seq'::regclass);


--
-- Name: clusters_applications_ingress id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_ingress ALTER COLUMN id SET DEFAULT nextval('public.clusters_applications_ingress_id_seq'::regclass);


--
-- Name: clusters_applications_jupyter id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_jupyter ALTER COLUMN id SET DEFAULT nextval('public.clusters_applications_jupyter_id_seq'::regclass);


--
-- Name: clusters_applications_knative id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_knative ALTER COLUMN id SET DEFAULT nextval('public.clusters_applications_knative_id_seq'::regclass);


--
-- Name: clusters_applications_prometheus id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_prometheus ALTER COLUMN id SET DEFAULT nextval('public.clusters_applications_prometheus_id_seq'::regclass);


--
-- Name: clusters_applications_runners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_runners ALTER COLUMN id SET DEFAULT nextval('public.clusters_applications_runners_id_seq'::regclass);


--
-- Name: clusters_kubernetes_namespaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_kubernetes_namespaces ALTER COLUMN id SET DEFAULT nextval('public.clusters_kubernetes_namespaces_id_seq'::regclass);


--
-- Name: container_repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.container_repositories ALTER COLUMN id SET DEFAULT nextval('public.container_repositories_id_seq'::regclass);


--
-- Name: conversational_development_index_metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversational_development_index_metrics ALTER COLUMN id SET DEFAULT nextval('public.conversational_development_index_metrics_id_seq'::regclass);


--
-- Name: dependency_proxy_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dependency_proxy_blobs ALTER COLUMN id SET DEFAULT nextval('public.dependency_proxy_blobs_id_seq'::regclass);


--
-- Name: dependency_proxy_group_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dependency_proxy_group_settings ALTER COLUMN id SET DEFAULT nextval('public.dependency_proxy_group_settings_id_seq'::regclass);


--
-- Name: deploy_keys_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploy_keys_projects ALTER COLUMN id SET DEFAULT nextval('public.deploy_keys_projects_id_seq'::regclass);


--
-- Name: deploy_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploy_tokens ALTER COLUMN id SET DEFAULT nextval('public.deploy_tokens_id_seq'::regclass);


--
-- Name: deployments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deployments ALTER COLUMN id SET DEFAULT nextval('public.deployments_id_seq'::regclass);


--
-- Name: design_management_designs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.design_management_designs ALTER COLUMN id SET DEFAULT nextval('public.design_management_designs_id_seq'::regclass);


--
-- Name: design_management_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.design_management_versions ALTER COLUMN id SET DEFAULT nextval('public.design_management_versions_id_seq'::regclass);


--
-- Name: draft_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_notes ALTER COLUMN id SET DEFAULT nextval('public.draft_notes_id_seq'::regclass);


--
-- Name: emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emails ALTER COLUMN id SET DEFAULT nextval('public.emails_id_seq'::regclass);


--
-- Name: environments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.environments ALTER COLUMN id SET DEFAULT nextval('public.environments_id_seq'::regclass);


--
-- Name: epic_issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epic_issues ALTER COLUMN id SET DEFAULT nextval('public.epic_issues_id_seq'::regclass);


--
-- Name: epic_metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epic_metrics ALTER COLUMN id SET DEFAULT nextval('public.epic_metrics_id_seq'::regclass);


--
-- Name: epics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epics ALTER COLUMN id SET DEFAULT nextval('public.epics_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: feature_gates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_gates ALTER COLUMN id SET DEFAULT nextval('public.feature_gates_id_seq'::regclass);


--
-- Name: features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.features ALTER COLUMN id SET DEFAULT nextval('public.features_id_seq'::regclass);


--
-- Name: fork_network_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fork_network_members ALTER COLUMN id SET DEFAULT nextval('public.fork_network_members_id_seq'::regclass);


--
-- Name: fork_networks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fork_networks ALTER COLUMN id SET DEFAULT nextval('public.fork_networks_id_seq'::regclass);


--
-- Name: forked_project_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forked_project_links ALTER COLUMN id SET DEFAULT nextval('public.forked_project_links_id_seq'::regclass);


--
-- Name: geo_cache_invalidation_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_cache_invalidation_events ALTER COLUMN id SET DEFAULT nextval('public.geo_cache_invalidation_events_id_seq'::regclass);


--
-- Name: geo_event_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log ALTER COLUMN id SET DEFAULT nextval('public.geo_event_log_id_seq'::regclass);


--
-- Name: geo_hashed_storage_attachments_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_hashed_storage_attachments_events ALTER COLUMN id SET DEFAULT nextval('public.geo_hashed_storage_attachments_events_id_seq'::regclass);


--
-- Name: geo_hashed_storage_migrated_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_hashed_storage_migrated_events ALTER COLUMN id SET DEFAULT nextval('public.geo_hashed_storage_migrated_events_id_seq'::regclass);


--
-- Name: geo_job_artifact_deleted_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_job_artifact_deleted_events ALTER COLUMN id SET DEFAULT nextval('public.geo_job_artifact_deleted_events_id_seq'::regclass);


--
-- Name: geo_lfs_object_deleted_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_lfs_object_deleted_events ALTER COLUMN id SET DEFAULT nextval('public.geo_lfs_object_deleted_events_id_seq'::regclass);


--
-- Name: geo_node_namespace_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_node_namespace_links ALTER COLUMN id SET DEFAULT nextval('public.geo_node_namespace_links_id_seq'::regclass);


--
-- Name: geo_node_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_node_statuses ALTER COLUMN id SET DEFAULT nextval('public.geo_node_statuses_id_seq'::regclass);


--
-- Name: geo_nodes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_nodes ALTER COLUMN id SET DEFAULT nextval('public.geo_nodes_id_seq'::regclass);


--
-- Name: geo_repositories_changed_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repositories_changed_events ALTER COLUMN id SET DEFAULT nextval('public.geo_repositories_changed_events_id_seq'::regclass);


--
-- Name: geo_repository_created_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_created_events ALTER COLUMN id SET DEFAULT nextval('public.geo_repository_created_events_id_seq'::regclass);


--
-- Name: geo_repository_deleted_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_deleted_events ALTER COLUMN id SET DEFAULT nextval('public.geo_repository_deleted_events_id_seq'::regclass);


--
-- Name: geo_repository_renamed_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_renamed_events ALTER COLUMN id SET DEFAULT nextval('public.geo_repository_renamed_events_id_seq'::regclass);


--
-- Name: geo_repository_updated_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_updated_events ALTER COLUMN id SET DEFAULT nextval('public.geo_repository_updated_events_id_seq'::regclass);


--
-- Name: geo_reset_checksum_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_reset_checksum_events ALTER COLUMN id SET DEFAULT nextval('public.geo_reset_checksum_events_id_seq'::regclass);


--
-- Name: geo_upload_deleted_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_upload_deleted_events ALTER COLUMN id SET DEFAULT nextval('public.geo_upload_deleted_events_id_seq'::regclass);


--
-- Name: gitlab_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gitlab_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.gitlab_subscriptions_id_seq'::regclass);


--
-- Name: gpg_key_subkeys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_key_subkeys ALTER COLUMN id SET DEFAULT nextval('public.gpg_key_subkeys_id_seq'::regclass);


--
-- Name: gpg_keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_keys ALTER COLUMN id SET DEFAULT nextval('public.gpg_keys_id_seq'::regclass);


--
-- Name: gpg_signatures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_signatures ALTER COLUMN id SET DEFAULT nextval('public.gpg_signatures_id_seq'::regclass);


--
-- Name: group_custom_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_custom_attributes ALTER COLUMN id SET DEFAULT nextval('public.group_custom_attributes_id_seq'::regclass);


--
-- Name: historical_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historical_data ALTER COLUMN id SET DEFAULT nextval('public.historical_data_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities ALTER COLUMN id SET DEFAULT nextval('public.identities_id_seq'::regclass);


--
-- Name: import_export_uploads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_export_uploads ALTER COLUMN id SET DEFAULT nextval('public.import_export_uploads_id_seq'::regclass);


--
-- Name: index_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.index_statuses ALTER COLUMN id SET DEFAULT nextval('public.index_statuses_id_seq'::regclass);


--
-- Name: insights id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insights ALTER COLUMN id SET DEFAULT nextval('public.insights_id_seq'::regclass);


--
-- Name: internal_ids id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internal_ids ALTER COLUMN id SET DEFAULT nextval('public.internal_ids_id_seq'::regclass);


--
-- Name: ip_restrictions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ip_restrictions ALTER COLUMN id SET DEFAULT nextval('public.ip_restrictions_id_seq'::regclass);


--
-- Name: issue_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_links ALTER COLUMN id SET DEFAULT nextval('public.issue_links_id_seq'::regclass);


--
-- Name: issue_metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_metrics ALTER COLUMN id SET DEFAULT nextval('public.issue_metrics_id_seq'::regclass);


--
-- Name: issue_tracker_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_tracker_data ALTER COLUMN id SET DEFAULT nextval('public.issue_tracker_data_id_seq'::regclass);


--
-- Name: issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues ALTER COLUMN id SET DEFAULT nextval('public.issues_id_seq'::regclass);


--
-- Name: jira_connect_installations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_connect_installations ALTER COLUMN id SET DEFAULT nextval('public.jira_connect_installations_id_seq'::regclass);


--
-- Name: jira_connect_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_connect_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.jira_connect_subscriptions_id_seq'::regclass);


--
-- Name: jira_tracker_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_tracker_data ALTER COLUMN id SET DEFAULT nextval('public.jira_tracker_data_id_seq'::regclass);


--
-- Name: keys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keys ALTER COLUMN id SET DEFAULT nextval('public.keys_id_seq'::regclass);


--
-- Name: label_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_links ALTER COLUMN id SET DEFAULT nextval('public.label_links_id_seq'::regclass);


--
-- Name: label_priorities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_priorities ALTER COLUMN id SET DEFAULT nextval('public.label_priorities_id_seq'::regclass);


--
-- Name: labels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labels ALTER COLUMN id SET DEFAULT nextval('public.labels_id_seq'::regclass);


--
-- Name: ldap_group_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ldap_group_links ALTER COLUMN id SET DEFAULT nextval('public.ldap_group_links_id_seq'::regclass);


--
-- Name: lfs_file_locks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lfs_file_locks ALTER COLUMN id SET DEFAULT nextval('public.lfs_file_locks_id_seq'::regclass);


--
-- Name: lfs_objects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lfs_objects ALTER COLUMN id SET DEFAULT nextval('public.lfs_objects_id_seq'::regclass);


--
-- Name: lfs_objects_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lfs_objects_projects ALTER COLUMN id SET DEFAULT nextval('public.lfs_objects_projects_id_seq'::regclass);


--
-- Name: licenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.licenses ALTER COLUMN id SET DEFAULT nextval('public.licenses_id_seq'::regclass);


--
-- Name: lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists ALTER COLUMN id SET DEFAULT nextval('public.lists_id_seq'::regclass);


--
-- Name: members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


--
-- Name: merge_request_assignees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_assignees ALTER COLUMN id SET DEFAULT nextval('public.merge_request_assignees_id_seq'::regclass);


--
-- Name: merge_request_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_blocks ALTER COLUMN id SET DEFAULT nextval('public.merge_request_blocks_id_seq'::regclass);


--
-- Name: merge_request_diffs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_diffs ALTER COLUMN id SET DEFAULT nextval('public.merge_request_diffs_id_seq'::regclass);


--
-- Name: merge_request_metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_metrics ALTER COLUMN id SET DEFAULT nextval('public.merge_request_metrics_id_seq'::regclass);


--
-- Name: merge_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests ALTER COLUMN id SET DEFAULT nextval('public.merge_requests_id_seq'::regclass);


--
-- Name: merge_requests_closing_issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests_closing_issues ALTER COLUMN id SET DEFAULT nextval('public.merge_requests_closing_issues_id_seq'::regclass);


--
-- Name: merge_trains id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_trains ALTER COLUMN id SET DEFAULT nextval('public.merge_trains_id_seq'::regclass);


--
-- Name: milestones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.milestones ALTER COLUMN id SET DEFAULT nextval('public.milestones_id_seq'::regclass);


--
-- Name: namespace_statistics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_statistics ALTER COLUMN id SET DEFAULT nextval('public.namespace_statistics_id_seq'::regclass);


--
-- Name: namespaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces ALTER COLUMN id SET DEFAULT nextval('public.namespaces_id_seq'::regclass);


--
-- Name: note_diff_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.note_diff_files ALTER COLUMN id SET DEFAULT nextval('public.note_diff_files_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: notification_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_settings ALTER COLUMN id SET DEFAULT nextval('public.notification_settings_id_seq'::regclass);


--
-- Name: oauth_access_grants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_grants_id_seq'::regclass);


--
-- Name: oauth_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.oauth_access_tokens_id_seq'::regclass);


--
-- Name: oauth_applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications ALTER COLUMN id SET DEFAULT nextval('public.oauth_applications_id_seq'::regclass);


--
-- Name: oauth_openid_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_openid_requests ALTER COLUMN id SET DEFAULT nextval('public.oauth_openid_requests_id_seq'::regclass);


--
-- Name: operations_feature_flag_scopes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flag_scopes ALTER COLUMN id SET DEFAULT nextval('public.operations_feature_flag_scopes_id_seq'::regclass);


--
-- Name: operations_feature_flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flags ALTER COLUMN id SET DEFAULT nextval('public.operations_feature_flags_id_seq'::regclass);


--
-- Name: operations_feature_flags_clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flags_clients ALTER COLUMN id SET DEFAULT nextval('public.operations_feature_flags_clients_id_seq'::regclass);


--
-- Name: packages_maven_metadata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_maven_metadata ALTER COLUMN id SET DEFAULT nextval('public.packages_maven_metadata_id_seq'::regclass);


--
-- Name: packages_package_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_package_files ALTER COLUMN id SET DEFAULT nextval('public.packages_package_files_id_seq'::regclass);


--
-- Name: packages_packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_packages ALTER COLUMN id SET DEFAULT nextval('public.packages_packages_id_seq'::regclass);


--
-- Name: pages_domain_acme_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages_domain_acme_orders ALTER COLUMN id SET DEFAULT nextval('public.pages_domain_acme_orders_id_seq'::regclass);


--
-- Name: pages_domains id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages_domains ALTER COLUMN id SET DEFAULT nextval('public.pages_domains_id_seq'::regclass);


--
-- Name: path_locks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.path_locks ALTER COLUMN id SET DEFAULT nextval('public.path_locks_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: pool_repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_repositories ALTER COLUMN id SET DEFAULT nextval('public.pool_repositories_id_seq'::regclass);


--
-- Name: programming_languages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programming_languages ALTER COLUMN id SET DEFAULT nextval('public.programming_languages_id_seq'::regclass);


--
-- Name: project_aliases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_aliases ALTER COLUMN id SET DEFAULT nextval('public.project_aliases_id_seq'::regclass);


--
-- Name: project_auto_devops id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_auto_devops ALTER COLUMN id SET DEFAULT nextval('public.project_auto_devops_id_seq'::regclass);


--
-- Name: project_ci_cd_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_ci_cd_settings ALTER COLUMN id SET DEFAULT nextval('public.project_ci_cd_settings_id_seq'::regclass);


--
-- Name: project_custom_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_custom_attributes ALTER COLUMN id SET DEFAULT nextval('public.project_custom_attributes_id_seq'::regclass);


--
-- Name: project_daily_statistics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_daily_statistics ALTER COLUMN id SET DEFAULT nextval('public.project_daily_statistics_id_seq'::regclass);


--
-- Name: project_deploy_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_deploy_tokens ALTER COLUMN id SET DEFAULT nextval('public.project_deploy_tokens_id_seq'::regclass);


--
-- Name: project_features id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_features ALTER COLUMN id SET DEFAULT nextval('public.project_features_id_seq'::regclass);


--
-- Name: project_group_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_group_links ALTER COLUMN id SET DEFAULT nextval('public.project_group_links_id_seq'::regclass);


--
-- Name: project_import_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_import_data ALTER COLUMN id SET DEFAULT nextval('public.project_import_data_id_seq'::regclass);


--
-- Name: project_incident_management_settings project_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_incident_management_settings ALTER COLUMN project_id SET DEFAULT nextval('public.project_incident_management_settings_project_id_seq'::regclass);


--
-- Name: project_mirror_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_mirror_data ALTER COLUMN id SET DEFAULT nextval('public.project_mirror_data_id_seq'::regclass);


--
-- Name: project_repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_repositories ALTER COLUMN id SET DEFAULT nextval('public.project_repositories_id_seq'::regclass);


--
-- Name: project_repository_states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_repository_states ALTER COLUMN id SET DEFAULT nextval('public.project_repository_states_id_seq'::regclass);


--
-- Name: project_statistics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_statistics ALTER COLUMN id SET DEFAULT nextval('public.project_statistics_id_seq'::regclass);


--
-- Name: project_tracing_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_tracing_settings ALTER COLUMN id SET DEFAULT nextval('public.project_tracing_settings_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: prometheus_alert_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alert_events ALTER COLUMN id SET DEFAULT nextval('public.prometheus_alert_events_id_seq'::regclass);


--
-- Name: prometheus_alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alerts ALTER COLUMN id SET DEFAULT nextval('public.prometheus_alerts_id_seq'::regclass);


--
-- Name: prometheus_metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_metrics ALTER COLUMN id SET DEFAULT nextval('public.prometheus_metrics_id_seq'::regclass);


--
-- Name: protected_branch_merge_access_levels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_merge_access_levels ALTER COLUMN id SET DEFAULT nextval('public.protected_branch_merge_access_levels_id_seq'::regclass);


--
-- Name: protected_branch_push_access_levels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_push_access_levels ALTER COLUMN id SET DEFAULT nextval('public.protected_branch_push_access_levels_id_seq'::regclass);


--
-- Name: protected_branch_unprotect_access_levels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_unprotect_access_levels ALTER COLUMN id SET DEFAULT nextval('public.protected_branch_unprotect_access_levels_id_seq'::regclass);


--
-- Name: protected_branches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branches ALTER COLUMN id SET DEFAULT nextval('public.protected_branches_id_seq'::regclass);


--
-- Name: protected_environment_deploy_access_levels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_environment_deploy_access_levels ALTER COLUMN id SET DEFAULT nextval('public.protected_environment_deploy_access_levels_id_seq'::regclass);


--
-- Name: protected_environments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_environments ALTER COLUMN id SET DEFAULT nextval('public.protected_environments_id_seq'::regclass);


--
-- Name: protected_tag_create_access_levels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_tag_create_access_levels ALTER COLUMN id SET DEFAULT nextval('public.protected_tag_create_access_levels_id_seq'::regclass);


--
-- Name: protected_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_tags ALTER COLUMN id SET DEFAULT nextval('public.protected_tags_id_seq'::regclass);


--
-- Name: push_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_rules ALTER COLUMN id SET DEFAULT nextval('public.push_rules_id_seq'::regclass);


--
-- Name: redirect_routes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redirect_routes ALTER COLUMN id SET DEFAULT nextval('public.redirect_routes_id_seq'::regclass);


--
-- Name: release_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.release_links ALTER COLUMN id SET DEFAULT nextval('public.release_links_id_seq'::regclass);


--
-- Name: releases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.releases ALTER COLUMN id SET DEFAULT nextval('public.releases_id_seq'::regclass);


--
-- Name: remote_mirrors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.remote_mirrors ALTER COLUMN id SET DEFAULT nextval('public.remote_mirrors_id_seq'::regclass);


--
-- Name: resource_label_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_label_events ALTER COLUMN id SET DEFAULT nextval('public.resource_label_events_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: routes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routes ALTER COLUMN id SET DEFAULT nextval('public.routes_id_seq'::regclass);


--
-- Name: saml_providers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saml_providers ALTER COLUMN id SET DEFAULT nextval('public.saml_providers_id_seq'::regclass);


--
-- Name: scim_oauth_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scim_oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.scim_oauth_access_tokens_id_seq'::regclass);


--
-- Name: sent_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sent_notifications ALTER COLUMN id SET DEFAULT nextval('public.sent_notifications_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: shards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shards ALTER COLUMN id SET DEFAULT nextval('public.shards_id_seq'::regclass);


--
-- Name: slack_integrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slack_integrations ALTER COLUMN id SET DEFAULT nextval('public.slack_integrations_id_seq'::regclass);


--
-- Name: smartcard_identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartcard_identities ALTER COLUMN id SET DEFAULT nextval('public.smartcard_identities_id_seq'::regclass);


--
-- Name: snippets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snippets ALTER COLUMN id SET DEFAULT nextval('public.snippets_id_seq'::regclass);


--
-- Name: software_license_policies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_license_policies ALTER COLUMN id SET DEFAULT nextval('public.software_license_policies_id_seq'::regclass);


--
-- Name: software_licenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_licenses ALTER COLUMN id SET DEFAULT nextval('public.software_licenses_id_seq'::regclass);


--
-- Name: spam_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spam_logs ALTER COLUMN id SET DEFAULT nextval('public.spam_logs_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: suggestions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suggestions ALTER COLUMN id SET DEFAULT nextval('public.suggestions_id_seq'::regclass);


--
-- Name: system_note_metadata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_note_metadata ALTER COLUMN id SET DEFAULT nextval('public.system_note_metadata_id_seq'::regclass);


--
-- Name: taggings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings ALTER COLUMN id SET DEFAULT nextval('public.taggings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: term_agreements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.term_agreements ALTER COLUMN id SET DEFAULT nextval('public.term_agreements_id_seq'::regclass);


--
-- Name: timelogs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelogs ALTER COLUMN id SET DEFAULT nextval('public.timelogs_id_seq'::regclass);


--
-- Name: todos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.todos ALTER COLUMN id SET DEFAULT nextval('public.todos_id_seq'::regclass);


--
-- Name: trending_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trending_projects ALTER COLUMN id SET DEFAULT nextval('public.trending_projects_id_seq'::regclass);


--
-- Name: u2f_registrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.u2f_registrations ALTER COLUMN id SET DEFAULT nextval('public.u2f_registrations_id_seq'::regclass);


--
-- Name: uploads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.uploads ALTER COLUMN id SET DEFAULT nextval('public.uploads_id_seq'::regclass);


--
-- Name: user_agent_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_agent_details ALTER COLUMN id SET DEFAULT nextval('public.user_agent_details_id_seq'::regclass);


--
-- Name: user_callouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_callouts ALTER COLUMN id SET DEFAULT nextval('public.user_callouts_id_seq'::regclass);


--
-- Name: user_custom_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_custom_attributes ALTER COLUMN id SET DEFAULT nextval('public.user_custom_attributes_id_seq'::regclass);


--
-- Name: user_preferences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_preferences ALTER COLUMN id SET DEFAULT nextval('public.user_preferences_id_seq'::regclass);


--
-- Name: user_statuses user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_statuses ALTER COLUMN user_id SET DEFAULT nextval('public.user_statuses_user_id_seq'::regclass);


--
-- Name: user_synced_attributes_metadata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_synced_attributes_metadata ALTER COLUMN id SET DEFAULT nextval('public.user_synced_attributes_metadata_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_ops_dashboard_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_ops_dashboard_projects ALTER COLUMN id SET DEFAULT nextval('public.users_ops_dashboard_projects_id_seq'::regclass);


--
-- Name: users_star_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_star_projects ALTER COLUMN id SET DEFAULT nextval('public.users_star_projects_id_seq'::regclass);


--
-- Name: vulnerability_feedback id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_feedback ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_feedback_id_seq'::regclass);


--
-- Name: vulnerability_identifiers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_identifiers ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_identifiers_id_seq'::regclass);


--
-- Name: vulnerability_occurrence_identifiers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrence_identifiers ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_occurrence_identifiers_id_seq'::regclass);


--
-- Name: vulnerability_occurrence_pipelines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrence_pipelines ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_occurrence_pipelines_id_seq'::regclass);


--
-- Name: vulnerability_occurrences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrences ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_occurrences_id_seq'::regclass);


--
-- Name: vulnerability_scanners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_scanners ALTER COLUMN id SET DEFAULT nextval('public.vulnerability_scanners_id_seq'::regclass);


--
-- Name: web_hook_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_hook_logs ALTER COLUMN id SET DEFAULT nextval('public.web_hook_logs_id_seq'::regclass);


--
-- Name: web_hooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_hooks ALTER COLUMN id SET DEFAULT nextval('public.web_hooks_id_seq'::regclass);


--
-- Name: abuse_reports abuse_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.abuse_reports
    ADD CONSTRAINT abuse_reports_pkey PRIMARY KEY (id);


--
-- Name: appearances appearances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appearances
    ADD CONSTRAINT appearances_pkey PRIMARY KEY (id);


--
-- Name: application_setting_terms application_setting_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_setting_terms
    ADD CONSTRAINT application_setting_terms_pkey PRIMARY KEY (id);


--
-- Name: application_settings application_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings
    ADD CONSTRAINT application_settings_pkey PRIMARY KEY (id);


--
-- Name: approval_merge_request_rule_sources approval_merge_request_rule_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rule_sources
    ADD CONSTRAINT approval_merge_request_rule_sources_pkey PRIMARY KEY (id);


--
-- Name: approval_merge_request_rules_approved_approvers approval_merge_request_rules_approved_approvers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_approved_approvers
    ADD CONSTRAINT approval_merge_request_rules_approved_approvers_pkey PRIMARY KEY (id);


--
-- Name: approval_merge_request_rules_groups approval_merge_request_rules_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_groups
    ADD CONSTRAINT approval_merge_request_rules_groups_pkey PRIMARY KEY (id);


--
-- Name: approval_merge_request_rules approval_merge_request_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules
    ADD CONSTRAINT approval_merge_request_rules_pkey PRIMARY KEY (id);


--
-- Name: approval_merge_request_rules_users approval_merge_request_rules_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_users
    ADD CONSTRAINT approval_merge_request_rules_users_pkey PRIMARY KEY (id);


--
-- Name: approval_project_rules_groups approval_project_rules_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules_groups
    ADD CONSTRAINT approval_project_rules_groups_pkey PRIMARY KEY (id);


--
-- Name: approval_project_rules approval_project_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules
    ADD CONSTRAINT approval_project_rules_pkey PRIMARY KEY (id);


--
-- Name: approval_project_rules_users approval_project_rules_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules_users
    ADD CONSTRAINT approval_project_rules_users_pkey PRIMARY KEY (id);


--
-- Name: approvals approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approvals
    ADD CONSTRAINT approvals_pkey PRIMARY KEY (id);


--
-- Name: approver_groups approver_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_groups
    ADD CONSTRAINT approver_groups_pkey PRIMARY KEY (id);


--
-- Name: approvers approvers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approvers
    ADD CONSTRAINT approvers_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: audit_events audit_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);


--
-- Name: award_emoji award_emoji_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.award_emoji
    ADD CONSTRAINT award_emoji_pkey PRIMARY KEY (id);


--
-- Name: badges badges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- Name: board_assignees board_assignees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_assignees
    ADD CONSTRAINT board_assignees_pkey PRIMARY KEY (id);


--
-- Name: board_group_recent_visits board_group_recent_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_group_recent_visits
    ADD CONSTRAINT board_group_recent_visits_pkey PRIMARY KEY (id);


--
-- Name: board_labels board_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_labels
    ADD CONSTRAINT board_labels_pkey PRIMARY KEY (id);


--
-- Name: board_project_recent_visits board_project_recent_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_project_recent_visits
    ADD CONSTRAINT board_project_recent_visits_pkey PRIMARY KEY (id);


--
-- Name: boards boards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT boards_pkey PRIMARY KEY (id);


--
-- Name: broadcast_messages broadcast_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broadcast_messages
    ADD CONSTRAINT broadcast_messages_pkey PRIMARY KEY (id);


--
-- Name: chat_names chat_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_names
    ADD CONSTRAINT chat_names_pkey PRIMARY KEY (id);


--
-- Name: chat_teams chat_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_teams
    ADD CONSTRAINT chat_teams_pkey PRIMARY KEY (id);


--
-- Name: ci_build_trace_chunks ci_build_trace_chunks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_chunks
    ADD CONSTRAINT ci_build_trace_chunks_pkey PRIMARY KEY (id);


--
-- Name: ci_build_trace_section_names ci_build_trace_section_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_section_names
    ADD CONSTRAINT ci_build_trace_section_names_pkey PRIMARY KEY (id);


--
-- Name: ci_build_trace_sections ci_build_trace_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_sections
    ADD CONSTRAINT ci_build_trace_sections_pkey PRIMARY KEY (id);


--
-- Name: ci_builds_metadata ci_builds_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds_metadata
    ADD CONSTRAINT ci_builds_metadata_pkey PRIMARY KEY (id);


--
-- Name: ci_builds ci_builds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds
    ADD CONSTRAINT ci_builds_pkey PRIMARY KEY (id);


--
-- Name: ci_builds_runner_session ci_builds_runner_session_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds_runner_session
    ADD CONSTRAINT ci_builds_runner_session_pkey PRIMARY KEY (id);


--
-- Name: ci_group_variables ci_group_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_group_variables
    ADD CONSTRAINT ci_group_variables_pkey PRIMARY KEY (id);


--
-- Name: ci_job_artifacts ci_job_artifacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_job_artifacts
    ADD CONSTRAINT ci_job_artifacts_pkey PRIMARY KEY (id);


--
-- Name: ci_pipeline_chat_data ci_pipeline_chat_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_chat_data
    ADD CONSTRAINT ci_pipeline_chat_data_pkey PRIMARY KEY (id);


--
-- Name: ci_pipeline_schedule_variables ci_pipeline_schedule_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_schedule_variables
    ADD CONSTRAINT ci_pipeline_schedule_variables_pkey PRIMARY KEY (id);


--
-- Name: ci_pipeline_schedules ci_pipeline_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_schedules
    ADD CONSTRAINT ci_pipeline_schedules_pkey PRIMARY KEY (id);


--
-- Name: ci_pipeline_variables ci_pipeline_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_variables
    ADD CONSTRAINT ci_pipeline_variables_pkey PRIMARY KEY (id);


--
-- Name: ci_pipelines ci_pipelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipelines
    ADD CONSTRAINT ci_pipelines_pkey PRIMARY KEY (id);


--
-- Name: ci_runner_namespaces ci_runner_namespaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runner_namespaces
    ADD CONSTRAINT ci_runner_namespaces_pkey PRIMARY KEY (id);


--
-- Name: ci_runner_projects ci_runner_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runner_projects
    ADD CONSTRAINT ci_runner_projects_pkey PRIMARY KEY (id);


--
-- Name: ci_runners ci_runners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runners
    ADD CONSTRAINT ci_runners_pkey PRIMARY KEY (id);


--
-- Name: ci_sources_pipelines ci_sources_pipelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_sources_pipelines
    ADD CONSTRAINT ci_sources_pipelines_pkey PRIMARY KEY (id);


--
-- Name: ci_stages ci_stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_stages
    ADD CONSTRAINT ci_stages_pkey PRIMARY KEY (id);


--
-- Name: ci_trigger_requests ci_trigger_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_trigger_requests
    ADD CONSTRAINT ci_trigger_requests_pkey PRIMARY KEY (id);


--
-- Name: ci_triggers ci_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_triggers
    ADD CONSTRAINT ci_triggers_pkey PRIMARY KEY (id);


--
-- Name: ci_variables ci_variables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_variables
    ADD CONSTRAINT ci_variables_pkey PRIMARY KEY (id);


--
-- Name: cluster_groups cluster_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_groups
    ADD CONSTRAINT cluster_groups_pkey PRIMARY KEY (id);


--
-- Name: cluster_platforms_kubernetes cluster_platforms_kubernetes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_platforms_kubernetes
    ADD CONSTRAINT cluster_platforms_kubernetes_pkey PRIMARY KEY (id);


--
-- Name: cluster_projects cluster_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_projects
    ADD CONSTRAINT cluster_projects_pkey PRIMARY KEY (id);


--
-- Name: cluster_providers_gcp cluster_providers_gcp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_providers_gcp
    ADD CONSTRAINT cluster_providers_gcp_pkey PRIMARY KEY (id);


--
-- Name: clusters_applications_cert_managers clusters_applications_cert_managers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_cert_managers
    ADD CONSTRAINT clusters_applications_cert_managers_pkey PRIMARY KEY (id);


--
-- Name: clusters_applications_helm clusters_applications_helm_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_helm
    ADD CONSTRAINT clusters_applications_helm_pkey PRIMARY KEY (id);


--
-- Name: clusters_applications_ingress clusters_applications_ingress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_ingress
    ADD CONSTRAINT clusters_applications_ingress_pkey PRIMARY KEY (id);


--
-- Name: clusters_applications_jupyter clusters_applications_jupyter_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_jupyter
    ADD CONSTRAINT clusters_applications_jupyter_pkey PRIMARY KEY (id);


--
-- Name: clusters_applications_knative clusters_applications_knative_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_knative
    ADD CONSTRAINT clusters_applications_knative_pkey PRIMARY KEY (id);


--
-- Name: clusters_applications_prometheus clusters_applications_prometheus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_prometheus
    ADD CONSTRAINT clusters_applications_prometheus_pkey PRIMARY KEY (id);


--
-- Name: clusters_applications_runners clusters_applications_runners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_runners
    ADD CONSTRAINT clusters_applications_runners_pkey PRIMARY KEY (id);


--
-- Name: clusters_kubernetes_namespaces clusters_kubernetes_namespaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_kubernetes_namespaces
    ADD CONSTRAINT clusters_kubernetes_namespaces_pkey PRIMARY KEY (id);


--
-- Name: clusters clusters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters
    ADD CONSTRAINT clusters_pkey PRIMARY KEY (id);


--
-- Name: container_repositories container_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.container_repositories
    ADD CONSTRAINT container_repositories_pkey PRIMARY KEY (id);


--
-- Name: conversational_development_index_metrics conversational_development_index_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversational_development_index_metrics
    ADD CONSTRAINT conversational_development_index_metrics_pkey PRIMARY KEY (id);


--
-- Name: dependency_proxy_blobs dependency_proxy_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dependency_proxy_blobs
    ADD CONSTRAINT dependency_proxy_blobs_pkey PRIMARY KEY (id);


--
-- Name: dependency_proxy_group_settings dependency_proxy_group_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dependency_proxy_group_settings
    ADD CONSTRAINT dependency_proxy_group_settings_pkey PRIMARY KEY (id);


--
-- Name: deploy_keys_projects deploy_keys_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploy_keys_projects
    ADD CONSTRAINT deploy_keys_projects_pkey PRIMARY KEY (id);


--
-- Name: deploy_tokens deploy_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploy_tokens
    ADD CONSTRAINT deploy_tokens_pkey PRIMARY KEY (id);


--
-- Name: deployments deployments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deployments
    ADD CONSTRAINT deployments_pkey PRIMARY KEY (id);


--
-- Name: design_management_designs design_management_designs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.design_management_designs
    ADD CONSTRAINT design_management_designs_pkey PRIMARY KEY (id);


--
-- Name: design_management_versions design_management_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.design_management_versions
    ADD CONSTRAINT design_management_versions_pkey PRIMARY KEY (id);


--
-- Name: draft_notes draft_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_notes
    ADD CONSTRAINT draft_notes_pkey PRIMARY KEY (id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: environments environments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.environments
    ADD CONSTRAINT environments_pkey PRIMARY KEY (id);


--
-- Name: epic_issues epic_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epic_issues
    ADD CONSTRAINT epic_issues_pkey PRIMARY KEY (id);


--
-- Name: epic_metrics epic_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epic_metrics
    ADD CONSTRAINT epic_metrics_pkey PRIMARY KEY (id);


--
-- Name: epics epics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT epics_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: feature_gates feature_gates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.feature_gates
    ADD CONSTRAINT feature_gates_pkey PRIMARY KEY (id);


--
-- Name: features features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.features
    ADD CONSTRAINT features_pkey PRIMARY KEY (id);


--
-- Name: fork_network_members fork_network_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fork_network_members
    ADD CONSTRAINT fork_network_members_pkey PRIMARY KEY (id);


--
-- Name: fork_networks fork_networks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fork_networks
    ADD CONSTRAINT fork_networks_pkey PRIMARY KEY (id);


--
-- Name: forked_project_links forked_project_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forked_project_links
    ADD CONSTRAINT forked_project_links_pkey PRIMARY KEY (id);


--
-- Name: geo_cache_invalidation_events geo_cache_invalidation_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_cache_invalidation_events
    ADD CONSTRAINT geo_cache_invalidation_events_pkey PRIMARY KEY (id);


--
-- Name: geo_event_log geo_event_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT geo_event_log_pkey PRIMARY KEY (id);


--
-- Name: geo_hashed_storage_attachments_events geo_hashed_storage_attachments_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_hashed_storage_attachments_events
    ADD CONSTRAINT geo_hashed_storage_attachments_events_pkey PRIMARY KEY (id);


--
-- Name: geo_hashed_storage_migrated_events geo_hashed_storage_migrated_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_hashed_storage_migrated_events
    ADD CONSTRAINT geo_hashed_storage_migrated_events_pkey PRIMARY KEY (id);


--
-- Name: geo_job_artifact_deleted_events geo_job_artifact_deleted_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_job_artifact_deleted_events
    ADD CONSTRAINT geo_job_artifact_deleted_events_pkey PRIMARY KEY (id);


--
-- Name: geo_lfs_object_deleted_events geo_lfs_object_deleted_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_lfs_object_deleted_events
    ADD CONSTRAINT geo_lfs_object_deleted_events_pkey PRIMARY KEY (id);


--
-- Name: geo_node_namespace_links geo_node_namespace_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_node_namespace_links
    ADD CONSTRAINT geo_node_namespace_links_pkey PRIMARY KEY (id);


--
-- Name: geo_node_statuses geo_node_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_node_statuses
    ADD CONSTRAINT geo_node_statuses_pkey PRIMARY KEY (id);


--
-- Name: geo_nodes geo_nodes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_nodes
    ADD CONSTRAINT geo_nodes_pkey PRIMARY KEY (id);


--
-- Name: geo_repositories_changed_events geo_repositories_changed_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repositories_changed_events
    ADD CONSTRAINT geo_repositories_changed_events_pkey PRIMARY KEY (id);


--
-- Name: geo_repository_created_events geo_repository_created_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_created_events
    ADD CONSTRAINT geo_repository_created_events_pkey PRIMARY KEY (id);


--
-- Name: geo_repository_deleted_events geo_repository_deleted_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_deleted_events
    ADD CONSTRAINT geo_repository_deleted_events_pkey PRIMARY KEY (id);


--
-- Name: geo_repository_renamed_events geo_repository_renamed_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_renamed_events
    ADD CONSTRAINT geo_repository_renamed_events_pkey PRIMARY KEY (id);


--
-- Name: geo_repository_updated_events geo_repository_updated_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_updated_events
    ADD CONSTRAINT geo_repository_updated_events_pkey PRIMARY KEY (id);


--
-- Name: geo_reset_checksum_events geo_reset_checksum_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_reset_checksum_events
    ADD CONSTRAINT geo_reset_checksum_events_pkey PRIMARY KEY (id);


--
-- Name: geo_upload_deleted_events geo_upload_deleted_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_upload_deleted_events
    ADD CONSTRAINT geo_upload_deleted_events_pkey PRIMARY KEY (id);


--
-- Name: gitlab_subscriptions gitlab_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gitlab_subscriptions
    ADD CONSTRAINT gitlab_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: gpg_key_subkeys gpg_key_subkeys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_key_subkeys
    ADD CONSTRAINT gpg_key_subkeys_pkey PRIMARY KEY (id);


--
-- Name: gpg_keys gpg_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_keys
    ADD CONSTRAINT gpg_keys_pkey PRIMARY KEY (id);


--
-- Name: gpg_signatures gpg_signatures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_signatures
    ADD CONSTRAINT gpg_signatures_pkey PRIMARY KEY (id);


--
-- Name: group_custom_attributes group_custom_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_custom_attributes
    ADD CONSTRAINT group_custom_attributes_pkey PRIMARY KEY (id);


--
-- Name: historical_data historical_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historical_data
    ADD CONSTRAINT historical_data_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: import_export_uploads import_export_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_export_uploads
    ADD CONSTRAINT import_export_uploads_pkey PRIMARY KEY (id);


--
-- Name: index_statuses index_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.index_statuses
    ADD CONSTRAINT index_statuses_pkey PRIMARY KEY (id);


--
-- Name: insights insights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insights
    ADD CONSTRAINT insights_pkey PRIMARY KEY (id);


--
-- Name: internal_ids internal_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internal_ids
    ADD CONSTRAINT internal_ids_pkey PRIMARY KEY (id);


--
-- Name: ip_restrictions ip_restrictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ip_restrictions
    ADD CONSTRAINT ip_restrictions_pkey PRIMARY KEY (id);


--
-- Name: issue_links issue_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_links
    ADD CONSTRAINT issue_links_pkey PRIMARY KEY (id);


--
-- Name: issue_metrics issue_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_metrics
    ADD CONSTRAINT issue_metrics_pkey PRIMARY KEY (id);


--
-- Name: issue_tracker_data issue_tracker_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_tracker_data
    ADD CONSTRAINT issue_tracker_data_pkey PRIMARY KEY (id);


--
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: jira_connect_installations jira_connect_installations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_connect_installations
    ADD CONSTRAINT jira_connect_installations_pkey PRIMARY KEY (id);


--
-- Name: jira_connect_subscriptions jira_connect_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_connect_subscriptions
    ADD CONSTRAINT jira_connect_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: jira_tracker_data jira_tracker_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_tracker_data
    ADD CONSTRAINT jira_tracker_data_pkey PRIMARY KEY (id);


--
-- Name: keys keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT keys_pkey PRIMARY KEY (id);


--
-- Name: label_links label_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_links
    ADD CONSTRAINT label_links_pkey PRIMARY KEY (id);


--
-- Name: label_priorities label_priorities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_priorities
    ADD CONSTRAINT label_priorities_pkey PRIMARY KEY (id);


--
-- Name: labels labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (id);


--
-- Name: ldap_group_links ldap_group_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ldap_group_links
    ADD CONSTRAINT ldap_group_links_pkey PRIMARY KEY (id);


--
-- Name: lfs_file_locks lfs_file_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lfs_file_locks
    ADD CONSTRAINT lfs_file_locks_pkey PRIMARY KEY (id);


--
-- Name: lfs_objects lfs_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lfs_objects
    ADD CONSTRAINT lfs_objects_pkey PRIMARY KEY (id);


--
-- Name: lfs_objects_projects lfs_objects_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lfs_objects_projects
    ADD CONSTRAINT lfs_objects_projects_pkey PRIMARY KEY (id);


--
-- Name: licenses licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: lists lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: merge_request_assignees merge_request_assignees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_assignees
    ADD CONSTRAINT merge_request_assignees_pkey PRIMARY KEY (id);


--
-- Name: merge_request_blocks merge_request_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_blocks
    ADD CONSTRAINT merge_request_blocks_pkey PRIMARY KEY (id);


--
-- Name: merge_request_diffs merge_request_diffs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_diffs
    ADD CONSTRAINT merge_request_diffs_pkey PRIMARY KEY (id);


--
-- Name: merge_request_metrics merge_request_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_metrics
    ADD CONSTRAINT merge_request_metrics_pkey PRIMARY KEY (id);


--
-- Name: merge_requests_closing_issues merge_requests_closing_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests_closing_issues
    ADD CONSTRAINT merge_requests_closing_issues_pkey PRIMARY KEY (id);


--
-- Name: merge_requests merge_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT merge_requests_pkey PRIMARY KEY (id);


--
-- Name: merge_trains merge_trains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_trains
    ADD CONSTRAINT merge_trains_pkey PRIMARY KEY (id);


--
-- Name: milestones milestones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.milestones
    ADD CONSTRAINT milestones_pkey PRIMARY KEY (id);


--
-- Name: namespace_aggregation_schedules namespace_aggregation_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_aggregation_schedules
    ADD CONSTRAINT namespace_aggregation_schedules_pkey PRIMARY KEY (namespace_id);


--
-- Name: namespace_root_storage_statistics namespace_root_storage_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_root_storage_statistics
    ADD CONSTRAINT namespace_root_storage_statistics_pkey PRIMARY KEY (namespace_id);


--
-- Name: namespace_statistics namespace_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_statistics
    ADD CONSTRAINT namespace_statistics_pkey PRIMARY KEY (id);


--
-- Name: namespaces namespaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces
    ADD CONSTRAINT namespaces_pkey PRIMARY KEY (id);


--
-- Name: note_diff_files note_diff_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.note_diff_files
    ADD CONSTRAINT note_diff_files_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: notification_settings notification_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_settings
    ADD CONSTRAINT notification_settings_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: oauth_openid_requests oauth_openid_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_openid_requests
    ADD CONSTRAINT oauth_openid_requests_pkey PRIMARY KEY (id);


--
-- Name: operations_feature_flag_scopes operations_feature_flag_scopes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flag_scopes
    ADD CONSTRAINT operations_feature_flag_scopes_pkey PRIMARY KEY (id);


--
-- Name: operations_feature_flags_clients operations_feature_flags_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flags_clients
    ADD CONSTRAINT operations_feature_flags_clients_pkey PRIMARY KEY (id);


--
-- Name: operations_feature_flags operations_feature_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flags
    ADD CONSTRAINT operations_feature_flags_pkey PRIMARY KEY (id);


--
-- Name: packages_maven_metadata packages_maven_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_maven_metadata
    ADD CONSTRAINT packages_maven_metadata_pkey PRIMARY KEY (id);


--
-- Name: packages_package_files packages_package_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_package_files
    ADD CONSTRAINT packages_package_files_pkey PRIMARY KEY (id);


--
-- Name: packages_packages packages_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_packages
    ADD CONSTRAINT packages_packages_pkey PRIMARY KEY (id);


--
-- Name: pages_domain_acme_orders pages_domain_acme_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages_domain_acme_orders
    ADD CONSTRAINT pages_domain_acme_orders_pkey PRIMARY KEY (id);


--
-- Name: pages_domains pages_domains_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages_domains
    ADD CONSTRAINT pages_domains_pkey PRIMARY KEY (id);


--
-- Name: path_locks path_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.path_locks
    ADD CONSTRAINT path_locks_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: pool_repositories pool_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_repositories
    ADD CONSTRAINT pool_repositories_pkey PRIMARY KEY (id);


--
-- Name: programming_languages programming_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.programming_languages
    ADD CONSTRAINT programming_languages_pkey PRIMARY KEY (id);


--
-- Name: project_alerting_settings project_alerting_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_alerting_settings
    ADD CONSTRAINT project_alerting_settings_pkey PRIMARY KEY (project_id);


--
-- Name: project_aliases project_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_aliases
    ADD CONSTRAINT project_aliases_pkey PRIMARY KEY (id);


--
-- Name: project_auto_devops project_auto_devops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_auto_devops
    ADD CONSTRAINT project_auto_devops_pkey PRIMARY KEY (id);


--
-- Name: project_ci_cd_settings project_ci_cd_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_ci_cd_settings
    ADD CONSTRAINT project_ci_cd_settings_pkey PRIMARY KEY (id);


--
-- Name: project_custom_attributes project_custom_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_custom_attributes
    ADD CONSTRAINT project_custom_attributes_pkey PRIMARY KEY (id);


--
-- Name: project_daily_statistics project_daily_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_daily_statistics
    ADD CONSTRAINT project_daily_statistics_pkey PRIMARY KEY (id);


--
-- Name: project_deploy_tokens project_deploy_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_deploy_tokens
    ADD CONSTRAINT project_deploy_tokens_pkey PRIMARY KEY (id);


--
-- Name: project_error_tracking_settings project_error_tracking_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_error_tracking_settings
    ADD CONSTRAINT project_error_tracking_settings_pkey PRIMARY KEY (project_id);


--
-- Name: project_feature_usages project_feature_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_feature_usages
    ADD CONSTRAINT project_feature_usages_pkey PRIMARY KEY (project_id);


--
-- Name: project_features project_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_features
    ADD CONSTRAINT project_features_pkey PRIMARY KEY (id);


--
-- Name: project_group_links project_group_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_group_links
    ADD CONSTRAINT project_group_links_pkey PRIMARY KEY (id);


--
-- Name: project_import_data project_import_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_import_data
    ADD CONSTRAINT project_import_data_pkey PRIMARY KEY (id);


--
-- Name: project_incident_management_settings project_incident_management_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_incident_management_settings
    ADD CONSTRAINT project_incident_management_settings_pkey PRIMARY KEY (project_id);


--
-- Name: project_metrics_settings project_metrics_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_metrics_settings
    ADD CONSTRAINT project_metrics_settings_pkey PRIMARY KEY (project_id);


--
-- Name: project_mirror_data project_mirror_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_mirror_data
    ADD CONSTRAINT project_mirror_data_pkey PRIMARY KEY (id);


--
-- Name: project_repositories project_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_repositories
    ADD CONSTRAINT project_repositories_pkey PRIMARY KEY (id);


--
-- Name: project_repository_states project_repository_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_repository_states
    ADD CONSTRAINT project_repository_states_pkey PRIMARY KEY (id);


--
-- Name: project_statistics project_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_statistics
    ADD CONSTRAINT project_statistics_pkey PRIMARY KEY (id);


--
-- Name: project_tracing_settings project_tracing_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_tracing_settings
    ADD CONSTRAINT project_tracing_settings_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: prometheus_alert_events prometheus_alert_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alert_events
    ADD CONSTRAINT prometheus_alert_events_pkey PRIMARY KEY (id);


--
-- Name: prometheus_alerts prometheus_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alerts
    ADD CONSTRAINT prometheus_alerts_pkey PRIMARY KEY (id);


--
-- Name: prometheus_metrics prometheus_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_metrics
    ADD CONSTRAINT prometheus_metrics_pkey PRIMARY KEY (id);


--
-- Name: protected_branch_merge_access_levels protected_branch_merge_access_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_merge_access_levels
    ADD CONSTRAINT protected_branch_merge_access_levels_pkey PRIMARY KEY (id);


--
-- Name: protected_branch_push_access_levels protected_branch_push_access_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_push_access_levels
    ADD CONSTRAINT protected_branch_push_access_levels_pkey PRIMARY KEY (id);


--
-- Name: protected_branch_unprotect_access_levels protected_branch_unprotect_access_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_unprotect_access_levels
    ADD CONSTRAINT protected_branch_unprotect_access_levels_pkey PRIMARY KEY (id);


--
-- Name: protected_branches protected_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branches
    ADD CONSTRAINT protected_branches_pkey PRIMARY KEY (id);


--
-- Name: protected_environment_deploy_access_levels protected_environment_deploy_access_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_environment_deploy_access_levels
    ADD CONSTRAINT protected_environment_deploy_access_levels_pkey PRIMARY KEY (id);


--
-- Name: protected_environments protected_environments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_environments
    ADD CONSTRAINT protected_environments_pkey PRIMARY KEY (id);


--
-- Name: protected_tag_create_access_levels protected_tag_create_access_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_tag_create_access_levels
    ADD CONSTRAINT protected_tag_create_access_levels_pkey PRIMARY KEY (id);


--
-- Name: protected_tags protected_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_tags
    ADD CONSTRAINT protected_tags_pkey PRIMARY KEY (id);


--
-- Name: push_rules push_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_rules
    ADD CONSTRAINT push_rules_pkey PRIMARY KEY (id);


--
-- Name: redirect_routes redirect_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redirect_routes
    ADD CONSTRAINT redirect_routes_pkey PRIMARY KEY (id);


--
-- Name: release_links release_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.release_links
    ADD CONSTRAINT release_links_pkey PRIMARY KEY (id);


--
-- Name: releases releases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.releases
    ADD CONSTRAINT releases_pkey PRIMARY KEY (id);


--
-- Name: remote_mirrors remote_mirrors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.remote_mirrors
    ADD CONSTRAINT remote_mirrors_pkey PRIMARY KEY (id);


--
-- Name: resource_label_events resource_label_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_label_events
    ADD CONSTRAINT resource_label_events_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: routes routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scim_oauth_access_tokens scim_oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scim_oauth_access_tokens
    ADD CONSTRAINT scim_oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: sent_notifications sent_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sent_notifications
    ADD CONSTRAINT sent_notifications_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: shards shards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shards
    ADD CONSTRAINT shards_pkey PRIMARY KEY (id);


--
-- Name: slack_integrations slack_integrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slack_integrations
    ADD CONSTRAINT slack_integrations_pkey PRIMARY KEY (id);


--
-- Name: smartcard_identities smartcard_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartcard_identities
    ADD CONSTRAINT smartcard_identities_pkey PRIMARY KEY (id);


--
-- Name: snippets snippets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snippets
    ADD CONSTRAINT snippets_pkey PRIMARY KEY (id);


--
-- Name: software_license_policies software_license_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_license_policies
    ADD CONSTRAINT software_license_policies_pkey PRIMARY KEY (id);


--
-- Name: software_licenses software_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_licenses
    ADD CONSTRAINT software_licenses_pkey PRIMARY KEY (id);


--
-- Name: spam_logs spam_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spam_logs
    ADD CONSTRAINT spam_logs_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: suggestions suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT suggestions_pkey PRIMARY KEY (id);


--
-- Name: system_note_metadata system_note_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_note_metadata
    ADD CONSTRAINT system_note_metadata_pkey PRIMARY KEY (id);


--
-- Name: taggings taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: term_agreements term_agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.term_agreements
    ADD CONSTRAINT term_agreements_pkey PRIMARY KEY (id);


--
-- Name: timelogs timelogs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelogs
    ADD CONSTRAINT timelogs_pkey PRIMARY KEY (id);


--
-- Name: todos todos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT todos_pkey PRIMARY KEY (id);


--
-- Name: trending_projects trending_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trending_projects
    ADD CONSTRAINT trending_projects_pkey PRIMARY KEY (id);


--
-- Name: u2f_registrations u2f_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.u2f_registrations
    ADD CONSTRAINT u2f_registrations_pkey PRIMARY KEY (id);


--
-- Name: uploads uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.uploads
    ADD CONSTRAINT uploads_pkey PRIMARY KEY (id);


--
-- Name: user_agent_details user_agent_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_agent_details
    ADD CONSTRAINT user_agent_details_pkey PRIMARY KEY (id);


--
-- Name: user_callouts user_callouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_callouts
    ADD CONSTRAINT user_callouts_pkey PRIMARY KEY (id);


--
-- Name: user_custom_attributes user_custom_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_custom_attributes
    ADD CONSTRAINT user_custom_attributes_pkey PRIMARY KEY (id);


--
-- Name: user_preferences user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_pkey PRIMARY KEY (id);


--
-- Name: user_statuses user_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_statuses
    ADD CONSTRAINT user_statuses_pkey PRIMARY KEY (user_id);


--
-- Name: user_synced_attributes_metadata user_synced_attributes_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_synced_attributes_metadata
    ADD CONSTRAINT user_synced_attributes_metadata_pkey PRIMARY KEY (id);


--
-- Name: users_ops_dashboard_projects users_ops_dashboard_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_ops_dashboard_projects
    ADD CONSTRAINT users_ops_dashboard_projects_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_star_projects users_star_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_star_projects
    ADD CONSTRAINT users_star_projects_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_feedback vulnerability_feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_feedback
    ADD CONSTRAINT vulnerability_feedback_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_identifiers vulnerability_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_identifiers
    ADD CONSTRAINT vulnerability_identifiers_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_occurrence_identifiers vulnerability_occurrence_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrence_identifiers
    ADD CONSTRAINT vulnerability_occurrence_identifiers_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_occurrence_pipelines vulnerability_occurrence_pipelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrence_pipelines
    ADD CONSTRAINT vulnerability_occurrence_pipelines_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_occurrences vulnerability_occurrences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrences
    ADD CONSTRAINT vulnerability_occurrences_pkey PRIMARY KEY (id);


--
-- Name: vulnerability_scanners vulnerability_scanners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_scanners
    ADD CONSTRAINT vulnerability_scanners_pkey PRIMARY KEY (id);


--
-- Name: web_hook_logs web_hook_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_hook_logs
    ADD CONSTRAINT web_hook_logs_pkey PRIMARY KEY (id);


--
-- Name: web_hooks web_hooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_hooks
    ADD CONSTRAINT web_hooks_pkey PRIMARY KEY (id);


--
-- Name: analytics_index_audit_events_on_created_at_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX analytics_index_audit_events_on_created_at_and_author_id ON public.audit_events USING btree (created_at, author_id);


--
-- Name: analytics_index_events_on_created_at_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX analytics_index_events_on_created_at_and_author_id ON public.events USING btree (created_at, author_id);


--
-- Name: approval_rule_name_index_for_code_owners; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX approval_rule_name_index_for_code_owners ON public.approval_merge_request_rules USING btree (merge_request_id, code_owner, name) WHERE (code_owner = true);


--
-- Name: design_management_designs_versions_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX design_management_designs_versions_uniqueness ON public.design_management_designs_versions USING btree (design_id, version_id);


--
-- Name: idx_issues_on_project_id_and_due_date_and_id_and_state_partial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_issues_on_project_id_and_due_date_and_id_and_state_partial ON public.issues USING btree (project_id, due_date, id, state) WHERE (due_date IS NOT NULL);


--
-- Name: idx_jira_connect_subscriptions_on_installation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_jira_connect_subscriptions_on_installation_id ON public.jira_connect_subscriptions USING btree (jira_connect_installation_id);


--
-- Name: idx_jira_connect_subscriptions_on_installation_id_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_jira_connect_subscriptions_on_installation_id_namespace_id ON public.jira_connect_subscriptions USING btree (jira_connect_installation_id, namespace_id);


--
-- Name: idx_proj_feat_usg_on_jira_dvcs_cloud_last_sync_at_and_proj_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_proj_feat_usg_on_jira_dvcs_cloud_last_sync_at_and_proj_id ON public.project_feature_usages USING btree (jira_dvcs_cloud_last_sync_at, project_id) WHERE (jira_dvcs_cloud_last_sync_at IS NOT NULL);


--
-- Name: idx_proj_feat_usg_on_jira_dvcs_server_last_sync_at_and_proj_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_proj_feat_usg_on_jira_dvcs_server_last_sync_at_and_proj_id ON public.project_feature_usages USING btree (jira_dvcs_server_last_sync_at, project_id) WHERE (jira_dvcs_server_last_sync_at IS NOT NULL);


--
-- Name: idx_project_repository_check_partial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_project_repository_check_partial ON public.projects USING btree (repository_storage, created_at) WHERE (last_repository_check_at IS NULL);


--
-- Name: idx_projects_on_repository_storage_last_repository_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_projects_on_repository_storage_last_repository_updated_at ON public.projects USING btree (id, repository_storage, last_repository_updated_at);


--
-- Name: idx_repository_states_on_last_repository_verification_ran_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_repository_states_on_last_repository_verification_ran_at ON public.project_repository_states USING btree (project_id, last_repository_verification_ran_at) WHERE ((repository_verification_checksum IS NOT NULL) AND (last_repository_verification_failure IS NULL));


--
-- Name: idx_repository_states_on_last_wiki_verification_ran_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_repository_states_on_last_wiki_verification_ran_at ON public.project_repository_states USING btree (project_id, last_wiki_verification_ran_at) WHERE ((wiki_verification_checksum IS NOT NULL) AND (last_wiki_verification_failure IS NULL));


--
-- Name: idx_repository_states_on_repository_failure_partial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_repository_states_on_repository_failure_partial ON public.project_repository_states USING btree (last_repository_verification_failure) WHERE (last_repository_verification_failure IS NOT NULL);


--
-- Name: idx_repository_states_on_wiki_failure_partial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_repository_states_on_wiki_failure_partial ON public.project_repository_states USING btree (last_wiki_verification_failure) WHERE (last_wiki_verification_failure IS NOT NULL);


--
-- Name: idx_repository_states_outdated_checksums; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_repository_states_outdated_checksums ON public.project_repository_states USING btree (project_id) WHERE (((repository_verification_checksum IS NULL) AND (last_repository_verification_failure IS NULL)) OR ((wiki_verification_checksum IS NULL) AND (last_wiki_verification_failure IS NULL)));


--
-- Name: index_application_settings_on_custom_project_templates_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_settings_on_custom_project_templates_group_id ON public.application_settings USING btree (custom_project_templates_group_id);


--
-- Name: index_application_settings_on_file_template_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_settings_on_file_template_project_id ON public.application_settings USING btree (file_template_project_id);


--
-- Name: index_application_settings_on_usage_stats_set_by_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_settings_on_usage_stats_set_by_user_id ON public.application_settings USING btree (usage_stats_set_by_user_id);


--
-- Name: index_approval_merge_request_rule_sources_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_approval_merge_request_rule_sources_1 ON public.approval_merge_request_rule_sources USING btree (approval_merge_request_rule_id);


--
-- Name: index_approval_merge_request_rule_sources_2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_merge_request_rule_sources_2 ON public.approval_merge_request_rule_sources USING btree (approval_project_rule_id);


--
-- Name: index_approval_merge_request_rules_1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_merge_request_rules_1 ON public.approval_merge_request_rules USING btree (merge_request_id, code_owner);


--
-- Name: index_approval_merge_request_rules_approved_approvers_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_approval_merge_request_rules_approved_approvers_1 ON public.approval_merge_request_rules_approved_approvers USING btree (approval_merge_request_rule_id, user_id);


--
-- Name: index_approval_merge_request_rules_approved_approvers_2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_merge_request_rules_approved_approvers_2 ON public.approval_merge_request_rules_approved_approvers USING btree (user_id);


--
-- Name: index_approval_merge_request_rules_groups_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_approval_merge_request_rules_groups_1 ON public.approval_merge_request_rules_groups USING btree (approval_merge_request_rule_id, group_id);


--
-- Name: index_approval_merge_request_rules_groups_2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_merge_request_rules_groups_2 ON public.approval_merge_request_rules_groups USING btree (group_id);


--
-- Name: index_approval_merge_request_rules_users_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_approval_merge_request_rules_users_1 ON public.approval_merge_request_rules_users USING btree (approval_merge_request_rule_id, user_id);


--
-- Name: index_approval_merge_request_rules_users_2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_merge_request_rules_users_2 ON public.approval_merge_request_rules_users USING btree (user_id);


--
-- Name: index_approval_project_rules_groups_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_approval_project_rules_groups_1 ON public.approval_project_rules_groups USING btree (approval_project_rule_id, group_id);


--
-- Name: index_approval_project_rules_groups_2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_project_rules_groups_2 ON public.approval_project_rules_groups USING btree (group_id);


--
-- Name: index_approval_project_rules_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_project_rules_on_project_id ON public.approval_project_rules USING btree (project_id);


--
-- Name: index_approval_project_rules_users_1; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_approval_project_rules_users_1 ON public.approval_project_rules_users USING btree (approval_project_rule_id, user_id);


--
-- Name: index_approval_project_rules_users_2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_project_rules_users_2 ON public.approval_project_rules_users USING btree (user_id);


--
-- Name: index_approval_rule_name_for_code_owners_rule_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_approval_rule_name_for_code_owners_rule_type ON public.approval_merge_request_rules USING btree (merge_request_id, rule_type, name) WHERE (rule_type = 2);


--
-- Name: index_approval_rules_code_owners_rule_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approval_rules_code_owners_rule_type ON public.approval_merge_request_rules USING btree (merge_request_id, rule_type) WHERE (rule_type = 2);


--
-- Name: index_approvals_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approvals_on_merge_request_id ON public.approvals USING btree (merge_request_id);


--
-- Name: index_approvals_on_user_id_and_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_approvals_on_user_id_and_merge_request_id ON public.approvals USING btree (user_id, merge_request_id);


--
-- Name: index_approver_groups_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approver_groups_on_group_id ON public.approver_groups USING btree (group_id);


--
-- Name: index_approver_groups_on_target_id_and_target_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approver_groups_on_target_id_and_target_type ON public.approver_groups USING btree (target_id, target_type);


--
-- Name: index_approvers_on_target_id_and_target_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approvers_on_target_id_and_target_type ON public.approvers USING btree (target_id, target_type);


--
-- Name: index_approvers_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_approvers_on_user_id ON public.approvers USING btree (user_id);


--
-- Name: index_audit_events_on_entity_id_and_entity_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audit_events_on_entity_id_and_entity_type ON public.audit_events USING btree (entity_id, entity_type);


--
-- Name: index_award_emoji_on_awardable_type_and_awardable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_award_emoji_on_awardable_type_and_awardable_id ON public.award_emoji USING btree (awardable_type, awardable_id);


--
-- Name: index_award_emoji_on_user_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_award_emoji_on_user_id_and_name ON public.award_emoji USING btree (user_id, name);


--
-- Name: index_badges_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_badges_on_group_id ON public.badges USING btree (group_id);


--
-- Name: index_badges_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_badges_on_project_id ON public.badges USING btree (project_id);


--
-- Name: index_board_assignees_on_assignee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_assignees_on_assignee_id ON public.board_assignees USING btree (assignee_id);


--
-- Name: index_board_assignees_on_board_id_and_assignee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_assignees_on_board_id_and_assignee_id ON public.board_assignees USING btree (board_id, assignee_id);


--
-- Name: index_board_group_recent_visits_on_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_group_recent_visits_on_board_id ON public.board_group_recent_visits USING btree (board_id);


--
-- Name: index_board_group_recent_visits_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_group_recent_visits_on_group_id ON public.board_group_recent_visits USING btree (group_id);


--
-- Name: index_board_group_recent_visits_on_user_group_and_board; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_group_recent_visits_on_user_group_and_board ON public.board_group_recent_visits USING btree (user_id, group_id, board_id);


--
-- Name: index_board_group_recent_visits_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_group_recent_visits_on_user_id ON public.board_group_recent_visits USING btree (user_id);


--
-- Name: index_board_labels_on_board_id_and_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_labels_on_board_id_and_label_id ON public.board_labels USING btree (board_id, label_id);


--
-- Name: index_board_labels_on_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_labels_on_label_id ON public.board_labels USING btree (label_id);


--
-- Name: index_board_project_recent_visits_on_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_project_recent_visits_on_board_id ON public.board_project_recent_visits USING btree (board_id);


--
-- Name: index_board_project_recent_visits_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_project_recent_visits_on_project_id ON public.board_project_recent_visits USING btree (project_id);


--
-- Name: index_board_project_recent_visits_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_board_project_recent_visits_on_user_id ON public.board_project_recent_visits USING btree (user_id);


--
-- Name: index_board_project_recent_visits_on_user_project_and_board; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_board_project_recent_visits_on_user_project_and_board ON public.board_project_recent_visits USING btree (user_id, project_id, board_id);


--
-- Name: index_boards_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boards_on_group_id ON public.boards USING btree (group_id);


--
-- Name: index_boards_on_milestone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boards_on_milestone_id ON public.boards USING btree (milestone_id);


--
-- Name: index_boards_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_boards_on_project_id ON public.boards USING btree (project_id);


--
-- Name: index_broadcast_messages_on_starts_at_and_ends_at_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broadcast_messages_on_starts_at_and_ends_at_and_id ON public.broadcast_messages USING btree (starts_at, ends_at, id);


--
-- Name: index_chat_names_on_service_id_and_team_id_and_chat_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_chat_names_on_service_id_and_team_id_and_chat_id ON public.chat_names USING btree (service_id, team_id, chat_id);


--
-- Name: index_chat_names_on_user_id_and_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_chat_names_on_user_id_and_service_id ON public.chat_names USING btree (user_id, service_id);


--
-- Name: index_chat_teams_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_chat_teams_on_namespace_id ON public.chat_teams USING btree (namespace_id);


--
-- Name: index_ci_build_trace_chunks_on_build_id_and_chunk_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_build_trace_chunks_on_build_id_and_chunk_index ON public.ci_build_trace_chunks USING btree (build_id, chunk_index);


--
-- Name: index_ci_build_trace_section_names_on_project_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_build_trace_section_names_on_project_id_and_name ON public.ci_build_trace_section_names USING btree (project_id, name);


--
-- Name: index_ci_build_trace_sections_on_build_id_and_section_name_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_build_trace_sections_on_build_id_and_section_name_id ON public.ci_build_trace_sections USING btree (build_id, section_name_id);


--
-- Name: index_ci_build_trace_sections_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_build_trace_sections_on_project_id ON public.ci_build_trace_sections USING btree (project_id);


--
-- Name: index_ci_build_trace_sections_on_section_name_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_build_trace_sections_on_section_name_id ON public.ci_build_trace_sections USING btree (section_name_id);


--
-- Name: index_ci_builds_metadata_on_build_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_builds_metadata_on_build_id ON public.ci_builds_metadata USING btree (build_id);


--
-- Name: index_ci_builds_metadata_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_metadata_on_project_id ON public.ci_builds_metadata USING btree (project_id);


--
-- Name: index_ci_builds_on_artifacts_expire_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_artifacts_expire_at ON public.ci_builds USING btree (artifacts_expire_at) WHERE (artifacts_file <> ''::text);


--
-- Name: index_ci_builds_on_auto_canceled_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_auto_canceled_by_id ON public.ci_builds USING btree (auto_canceled_by_id);


--
-- Name: index_ci_builds_on_commit_id_and_artifacts_expireatandidpartial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_commit_id_and_artifacts_expireatandidpartial ON public.ci_builds USING btree (commit_id, artifacts_expire_at, id) WHERE (((type)::text = 'Ci::Build'::text) AND ((retried = false) OR (retried IS NULL)) AND ((name)::text = ANY (ARRAY[('sast'::character varying)::text, ('dependency_scanning'::character varying)::text, ('sast:container'::character varying)::text, ('container_scanning'::character varying)::text, ('dast'::character varying)::text])));


--
-- Name: index_ci_builds_on_commit_id_and_stage_idx_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_commit_id_and_stage_idx_and_created_at ON public.ci_builds USING btree (commit_id, stage_idx, created_at);


--
-- Name: index_ci_builds_on_commit_id_and_status_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_commit_id_and_status_and_type ON public.ci_builds USING btree (commit_id, status, type);


--
-- Name: index_ci_builds_on_commit_id_and_type_and_name_and_ref; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_commit_id_and_type_and_name_and_ref ON public.ci_builds USING btree (commit_id, type, name, ref);


--
-- Name: index_ci_builds_on_commit_id_and_type_and_ref; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_commit_id_and_type_and_ref ON public.ci_builds USING btree (commit_id, type, ref);


--
-- Name: index_ci_builds_on_name_for_security_products_values; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_name_for_security_products_values ON public.ci_builds USING btree (name) WHERE ((name)::text = ANY (ARRAY[('container_scanning'::character varying)::text, ('dast'::character varying)::text, ('dependency_scanning'::character varying)::text, ('license_management'::character varying)::text, ('sast'::character varying)::text]));


--
-- Name: index_ci_builds_on_project_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_project_id_and_id ON public.ci_builds USING btree (project_id, id);


--
-- Name: index_ci_builds_on_protected; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_protected ON public.ci_builds USING btree (protected);


--
-- Name: index_ci_builds_on_queued_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_queued_at ON public.ci_builds USING btree (queued_at);


--
-- Name: index_ci_builds_on_runner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_runner_id ON public.ci_builds USING btree (runner_id);


--
-- Name: index_ci_builds_on_stage_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_stage_id ON public.ci_builds USING btree (stage_id);


--
-- Name: index_ci_builds_on_status_and_type_and_runner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_status_and_type_and_runner_id ON public.ci_builds USING btree (status, type, runner_id);


--
-- Name: index_ci_builds_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_builds_on_token ON public.ci_builds USING btree (token);


--
-- Name: index_ci_builds_on_token_encrypted; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_builds_on_token_encrypted ON public.ci_builds USING btree (token_encrypted) WHERE (token_encrypted IS NOT NULL);


--
-- Name: index_ci_builds_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_updated_at ON public.ci_builds USING btree (updated_at);


--
-- Name: index_ci_builds_on_upstream_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_upstream_pipeline_id ON public.ci_builds USING btree (upstream_pipeline_id) WHERE (upstream_pipeline_id IS NOT NULL);


--
-- Name: index_ci_builds_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_on_user_id ON public.ci_builds USING btree (user_id);


--
-- Name: index_ci_builds_project_id_and_status_for_live_jobs_partial2; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_builds_project_id_and_status_for_live_jobs_partial2 ON public.ci_builds USING btree (project_id, status) WHERE (((type)::text = 'Ci::Build'::text) AND ((status)::text = ANY (ARRAY[('running'::character varying)::text, ('pending'::character varying)::text, ('created'::character varying)::text])));


--
-- Name: index_ci_builds_runner_session_on_build_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_builds_runner_session_on_build_id ON public.ci_builds_runner_session USING btree (build_id);


--
-- Name: index_ci_group_variables_on_group_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_group_variables_on_group_id_and_key ON public.ci_group_variables USING btree (group_id, key);


--
-- Name: index_ci_job_artifacts_on_expire_at_and_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_job_artifacts_on_expire_at_and_job_id ON public.ci_job_artifacts USING btree (expire_at, job_id);


--
-- Name: index_ci_job_artifacts_on_file_store; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_job_artifacts_on_file_store ON public.ci_job_artifacts USING btree (file_store);


--
-- Name: index_ci_job_artifacts_on_job_id_and_file_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_job_artifacts_on_job_id_and_file_type ON public.ci_job_artifacts USING btree (job_id, file_type);


--
-- Name: index_ci_job_artifacts_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_job_artifacts_on_project_id ON public.ci_job_artifacts USING btree (project_id);


--
-- Name: index_ci_pipeline_chat_data_on_chat_name_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipeline_chat_data_on_chat_name_id ON public.ci_pipeline_chat_data USING btree (chat_name_id);


--
-- Name: index_ci_pipeline_chat_data_on_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_pipeline_chat_data_on_pipeline_id ON public.ci_pipeline_chat_data USING btree (pipeline_id);


--
-- Name: index_ci_pipeline_schedule_variables_on_schedule_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_pipeline_schedule_variables_on_schedule_id_and_key ON public.ci_pipeline_schedule_variables USING btree (pipeline_schedule_id, key);


--
-- Name: index_ci_pipeline_schedules_on_next_run_at_and_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipeline_schedules_on_next_run_at_and_active ON public.ci_pipeline_schedules USING btree (next_run_at, active);


--
-- Name: index_ci_pipeline_schedules_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipeline_schedules_on_owner_id ON public.ci_pipeline_schedules USING btree (owner_id);


--
-- Name: index_ci_pipeline_schedules_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipeline_schedules_on_project_id ON public.ci_pipeline_schedules USING btree (project_id);


--
-- Name: index_ci_pipeline_variables_on_pipeline_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_pipeline_variables_on_pipeline_id_and_key ON public.ci_pipeline_variables USING btree (pipeline_id, key);


--
-- Name: index_ci_pipelines_on_auto_canceled_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_auto_canceled_by_id ON public.ci_pipelines USING btree (auto_canceled_by_id);


--
-- Name: index_ci_pipelines_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_merge_request_id ON public.ci_pipelines USING btree (merge_request_id) WHERE (merge_request_id IS NOT NULL);


--
-- Name: index_ci_pipelines_on_pipeline_schedule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_pipeline_schedule_id ON public.ci_pipelines USING btree (pipeline_schedule_id);


--
-- Name: index_ci_pipelines_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_project_id ON public.ci_pipelines USING btree (project_id);


--
-- Name: index_ci_pipelines_on_project_id_and_iid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_pipelines_on_project_id_and_iid ON public.ci_pipelines USING btree (project_id, iid) WHERE (iid IS NOT NULL);


--
-- Name: index_ci_pipelines_on_project_id_and_ref_and_status_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_project_id_and_ref_and_status_and_id ON public.ci_pipelines USING btree (project_id, ref, status, id);


--
-- Name: index_ci_pipelines_on_project_id_and_sha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_project_id_and_sha ON public.ci_pipelines USING btree (project_id, sha);


--
-- Name: index_ci_pipelines_on_project_id_and_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_project_id_and_source ON public.ci_pipelines USING btree (project_id, source);


--
-- Name: index_ci_pipelines_on_project_id_and_status_and_config_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_project_id_and_status_and_config_source ON public.ci_pipelines USING btree (project_id, status, config_source);


--
-- Name: index_ci_pipelines_on_project_idandrefandiddesc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_project_idandrefandiddesc ON public.ci_pipelines USING btree (project_id, ref, id DESC);


--
-- Name: index_ci_pipelines_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_status ON public.ci_pipelines USING btree (status);


--
-- Name: index_ci_pipelines_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_pipelines_on_user_id ON public.ci_pipelines USING btree (user_id);


--
-- Name: index_ci_runner_namespaces_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runner_namespaces_on_namespace_id ON public.ci_runner_namespaces USING btree (namespace_id);


--
-- Name: index_ci_runner_namespaces_on_runner_id_and_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_runner_namespaces_on_runner_id_and_namespace_id ON public.ci_runner_namespaces USING btree (runner_id, namespace_id);


--
-- Name: index_ci_runner_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runner_projects_on_project_id ON public.ci_runner_projects USING btree (project_id);


--
-- Name: index_ci_runner_projects_on_runner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runner_projects_on_runner_id ON public.ci_runner_projects USING btree (runner_id);


--
-- Name: index_ci_runners_on_contacted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runners_on_contacted_at ON public.ci_runners USING btree (contacted_at);


--
-- Name: index_ci_runners_on_is_shared; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runners_on_is_shared ON public.ci_runners USING btree (is_shared);


--
-- Name: index_ci_runners_on_locked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runners_on_locked ON public.ci_runners USING btree (locked);


--
-- Name: index_ci_runners_on_runner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runners_on_runner_type ON public.ci_runners USING btree (runner_type);


--
-- Name: index_ci_runners_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runners_on_token ON public.ci_runners USING btree (token);


--
-- Name: index_ci_runners_on_token_encrypted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_runners_on_token_encrypted ON public.ci_runners USING btree (token_encrypted);


--
-- Name: index_ci_sources_pipelines_on_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_sources_pipelines_on_pipeline_id ON public.ci_sources_pipelines USING btree (pipeline_id);


--
-- Name: index_ci_sources_pipelines_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_sources_pipelines_on_project_id ON public.ci_sources_pipelines USING btree (project_id);


--
-- Name: index_ci_sources_pipelines_on_source_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_sources_pipelines_on_source_job_id ON public.ci_sources_pipelines USING btree (source_job_id);


--
-- Name: index_ci_sources_pipelines_on_source_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_sources_pipelines_on_source_pipeline_id ON public.ci_sources_pipelines USING btree (source_pipeline_id);


--
-- Name: index_ci_sources_pipelines_on_source_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_sources_pipelines_on_source_project_id ON public.ci_sources_pipelines USING btree (source_project_id);


--
-- Name: index_ci_stages_on_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_stages_on_pipeline_id ON public.ci_stages USING btree (pipeline_id);


--
-- Name: index_ci_stages_on_pipeline_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_stages_on_pipeline_id_and_name ON public.ci_stages USING btree (pipeline_id, name);


--
-- Name: index_ci_stages_on_pipeline_id_and_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_stages_on_pipeline_id_and_position ON public.ci_stages USING btree (pipeline_id, "position");


--
-- Name: index_ci_stages_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_stages_on_project_id ON public.ci_stages USING btree (project_id);


--
-- Name: index_ci_trigger_requests_on_commit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_trigger_requests_on_commit_id ON public.ci_trigger_requests USING btree (commit_id);


--
-- Name: index_ci_trigger_requests_on_trigger_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_trigger_requests_on_trigger_id ON public.ci_trigger_requests USING btree (trigger_id);


--
-- Name: index_ci_triggers_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_triggers_on_owner_id ON public.ci_triggers USING btree (owner_id);


--
-- Name: index_ci_triggers_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ci_triggers_on_project_id ON public.ci_triggers USING btree (project_id);


--
-- Name: index_ci_variables_on_project_id_and_key_and_environment_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ci_variables_on_project_id_and_key_and_environment_scope ON public.ci_variables USING btree (project_id, key, environment_scope);


--
-- Name: index_cluster_groups_on_cluster_id_and_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cluster_groups_on_cluster_id_and_group_id ON public.cluster_groups USING btree (cluster_id, group_id);


--
-- Name: index_cluster_groups_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cluster_groups_on_group_id ON public.cluster_groups USING btree (group_id);


--
-- Name: index_cluster_platforms_kubernetes_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cluster_platforms_kubernetes_on_cluster_id ON public.cluster_platforms_kubernetes USING btree (cluster_id);


--
-- Name: index_cluster_projects_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cluster_projects_on_cluster_id ON public.cluster_projects USING btree (cluster_id);


--
-- Name: index_cluster_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cluster_projects_on_project_id ON public.cluster_projects USING btree (project_id);


--
-- Name: index_cluster_providers_gcp_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_cluster_providers_gcp_on_cluster_id ON public.cluster_providers_gcp USING btree (cluster_id);


--
-- Name: index_clusters_applications_cert_managers_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clusters_applications_cert_managers_on_cluster_id ON public.clusters_applications_cert_managers USING btree (cluster_id);


--
-- Name: index_clusters_applications_helm_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clusters_applications_helm_on_cluster_id ON public.clusters_applications_helm USING btree (cluster_id);


--
-- Name: index_clusters_applications_ingress_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clusters_applications_ingress_on_cluster_id ON public.clusters_applications_ingress USING btree (cluster_id);


--
-- Name: index_clusters_applications_jupyter_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clusters_applications_jupyter_on_cluster_id ON public.clusters_applications_jupyter USING btree (cluster_id);


--
-- Name: index_clusters_applications_jupyter_on_oauth_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clusters_applications_jupyter_on_oauth_application_id ON public.clusters_applications_jupyter USING btree (oauth_application_id);


--
-- Name: index_clusters_applications_knative_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clusters_applications_knative_on_cluster_id ON public.clusters_applications_knative USING btree (cluster_id);


--
-- Name: index_clusters_applications_prometheus_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clusters_applications_prometheus_on_cluster_id ON public.clusters_applications_prometheus USING btree (cluster_id);


--
-- Name: index_clusters_applications_runners_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_clusters_applications_runners_on_cluster_id ON public.clusters_applications_runners USING btree (cluster_id);


--
-- Name: index_clusters_applications_runners_on_runner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clusters_applications_runners_on_runner_id ON public.clusters_applications_runners USING btree (runner_id);


--
-- Name: index_clusters_kubernetes_namespaces_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clusters_kubernetes_namespaces_on_cluster_id ON public.clusters_kubernetes_namespaces USING btree (cluster_id);


--
-- Name: index_clusters_kubernetes_namespaces_on_cluster_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clusters_kubernetes_namespaces_on_cluster_project_id ON public.clusters_kubernetes_namespaces USING btree (cluster_project_id);


--
-- Name: index_clusters_kubernetes_namespaces_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clusters_kubernetes_namespaces_on_project_id ON public.clusters_kubernetes_namespaces USING btree (project_id);


--
-- Name: index_clusters_on_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clusters_on_enabled ON public.clusters USING btree (enabled);


--
-- Name: index_clusters_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clusters_on_user_id ON public.clusters USING btree (user_id);


--
-- Name: index_container_repositories_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_container_repositories_on_project_id ON public.container_repositories USING btree (project_id);


--
-- Name: index_container_repositories_on_project_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_container_repositories_on_project_id_and_name ON public.container_repositories USING btree (project_id, name);


--
-- Name: index_dependency_proxy_blobs_on_group_id_and_file_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dependency_proxy_blobs_on_group_id_and_file_name ON public.dependency_proxy_blobs USING btree (group_id, file_name);


--
-- Name: index_dependency_proxy_group_settings_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dependency_proxy_group_settings_on_group_id ON public.dependency_proxy_group_settings USING btree (group_id);


--
-- Name: index_deploy_keys_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deploy_keys_projects_on_project_id ON public.deploy_keys_projects USING btree (project_id);


--
-- Name: index_deploy_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_deploy_tokens_on_token ON public.deploy_tokens USING btree (token);


--
-- Name: index_deploy_tokens_on_token_and_expires_at_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deploy_tokens_on_token_and_expires_at_and_id ON public.deploy_tokens USING btree (token, expires_at, id) WHERE (revoked IS FALSE);


--
-- Name: index_deployments_on_cluster_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deployments_on_cluster_id ON public.deployments USING btree (cluster_id);


--
-- Name: index_deployments_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deployments_on_created_at ON public.deployments USING btree (created_at);


--
-- Name: index_deployments_on_deployable_type_and_deployable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deployments_on_deployable_type_and_deployable_id ON public.deployments USING btree (deployable_type, deployable_id);


--
-- Name: index_deployments_on_environment_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deployments_on_environment_id_and_id ON public.deployments USING btree (environment_id, id);


--
-- Name: index_deployments_on_environment_id_and_iid_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deployments_on_environment_id_and_iid_and_project_id ON public.deployments USING btree (environment_id, iid, project_id);


--
-- Name: index_deployments_on_environment_id_and_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deployments_on_environment_id_and_status ON public.deployments USING btree (environment_id, status);


--
-- Name: index_deployments_on_project_id_and_iid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_deployments_on_project_id_and_iid ON public.deployments USING btree (project_id, iid);


--
-- Name: index_deployments_on_project_id_and_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deployments_on_project_id_and_status ON public.deployments USING btree (project_id, status);


--
-- Name: index_deployments_on_project_id_and_status_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deployments_on_project_id_and_status_and_created_at ON public.deployments USING btree (project_id, status, created_at);


--
-- Name: index_design_management_designs_on_issue_id_and_filename; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_design_management_designs_on_issue_id_and_filename ON public.design_management_designs USING btree (issue_id, filename);


--
-- Name: index_design_management_designs_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_design_management_designs_on_project_id ON public.design_management_designs USING btree (project_id);


--
-- Name: index_design_management_designs_versions_on_design_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_design_management_designs_versions_on_design_id ON public.design_management_designs_versions USING btree (design_id);


--
-- Name: index_design_management_designs_versions_on_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_design_management_designs_versions_on_version_id ON public.design_management_designs_versions USING btree (version_id);


--
-- Name: index_design_management_versions_on_sha; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_design_management_versions_on_sha ON public.design_management_versions USING btree (sha);


--
-- Name: index_draft_notes_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_notes_on_author_id ON public.draft_notes USING btree (author_id);


--
-- Name: index_draft_notes_on_discussion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_notes_on_discussion_id ON public.draft_notes USING btree (discussion_id);


--
-- Name: index_draft_notes_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_draft_notes_on_merge_request_id ON public.draft_notes USING btree (merge_request_id);


--
-- Name: index_elasticsearch_indexed_namespaces_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_elasticsearch_indexed_namespaces_on_namespace_id ON public.elasticsearch_indexed_namespaces USING btree (namespace_id);


--
-- Name: index_elasticsearch_indexed_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_elasticsearch_indexed_projects_on_project_id ON public.elasticsearch_indexed_projects USING btree (project_id);


--
-- Name: index_emails_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_emails_on_confirmation_token ON public.emails USING btree (confirmation_token);


--
-- Name: index_emails_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_emails_on_email ON public.emails USING btree (email);


--
-- Name: index_emails_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_emails_on_user_id ON public.emails USING btree (user_id);


--
-- Name: index_environments_on_name_varchar_pattern_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_environments_on_name_varchar_pattern_ops ON public.environments USING btree (name varchar_pattern_ops);


--
-- Name: index_environments_on_project_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_environments_on_project_id_and_name ON public.environments USING btree (project_id, name);


--
-- Name: index_environments_on_project_id_and_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_environments_on_project_id_and_slug ON public.environments USING btree (project_id, slug);


--
-- Name: index_epic_issues_on_epic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epic_issues_on_epic_id ON public.epic_issues USING btree (epic_id);


--
-- Name: index_epic_issues_on_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_epic_issues_on_issue_id ON public.epic_issues USING btree (issue_id);


--
-- Name: index_epic_metrics; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epic_metrics ON public.epic_metrics USING btree (epic_id);


--
-- Name: index_epics_on_assignee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epics_on_assignee_id ON public.epics USING btree (assignee_id);


--
-- Name: index_epics_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epics_on_author_id ON public.epics USING btree (author_id);


--
-- Name: index_epics_on_closed_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epics_on_closed_by_id ON public.epics USING btree (closed_by_id);


--
-- Name: index_epics_on_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epics_on_end_date ON public.epics USING btree (end_date);


--
-- Name: index_epics_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epics_on_group_id ON public.epics USING btree (group_id);


--
-- Name: index_epics_on_iid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epics_on_iid ON public.epics USING btree (iid);


--
-- Name: index_epics_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epics_on_parent_id ON public.epics USING btree (parent_id);


--
-- Name: index_epics_on_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_epics_on_start_date ON public.epics USING btree (start_date);


--
-- Name: index_events_on_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_action ON public.events USING btree (action);


--
-- Name: index_events_on_author_id_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_author_id_and_project_id ON public.events USING btree (author_id, project_id);


--
-- Name: index_events_on_project_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_project_id_and_created_at ON public.events USING btree (project_id, created_at);


--
-- Name: index_events_on_project_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_project_id_and_id ON public.events USING btree (project_id, id);


--
-- Name: index_events_on_target_type_and_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_target_type_and_target_id ON public.events USING btree (target_type, target_id);


--
-- Name: index_feature_flag_scopes_on_flag_id_and_environment_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_feature_flag_scopes_on_flag_id_and_environment_scope ON public.operations_feature_flag_scopes USING btree (feature_flag_id, environment_scope);


--
-- Name: index_feature_flags_clients_on_project_id_and_token_encrypted; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_feature_flags_clients_on_project_id_and_token_encrypted ON public.operations_feature_flags_clients USING btree (project_id, token_encrypted);


--
-- Name: index_feature_gates_on_feature_key_and_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_feature_gates_on_feature_key_and_key_and_value ON public.feature_gates USING btree (feature_key, key, value);


--
-- Name: index_features_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_features_on_key ON public.features USING btree (key);


--
-- Name: index_fork_network_members_on_fork_network_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fork_network_members_on_fork_network_id ON public.fork_network_members USING btree (fork_network_id);


--
-- Name: index_fork_network_members_on_forked_from_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fork_network_members_on_forked_from_project_id ON public.fork_network_members USING btree (forked_from_project_id);


--
-- Name: index_fork_network_members_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fork_network_members_on_project_id ON public.fork_network_members USING btree (project_id);


--
-- Name: index_fork_networks_on_root_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fork_networks_on_root_project_id ON public.fork_networks USING btree (root_project_id);


--
-- Name: index_forked_project_links_on_forked_to_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_forked_project_links_on_forked_to_project_id ON public.forked_project_links USING btree (forked_to_project_id);


--
-- Name: index_geo_event_log_on_cache_invalidation_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_cache_invalidation_event_id ON public.geo_event_log USING btree (cache_invalidation_event_id) WHERE (cache_invalidation_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_hashed_storage_attachments_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_hashed_storage_attachments_event_id ON public.geo_event_log USING btree (hashed_storage_attachments_event_id) WHERE (hashed_storage_attachments_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_hashed_storage_migrated_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_hashed_storage_migrated_event_id ON public.geo_event_log USING btree (hashed_storage_migrated_event_id) WHERE (hashed_storage_migrated_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_job_artifact_deleted_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_job_artifact_deleted_event_id ON public.geo_event_log USING btree (job_artifact_deleted_event_id) WHERE (job_artifact_deleted_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_lfs_object_deleted_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_lfs_object_deleted_event_id ON public.geo_event_log USING btree (lfs_object_deleted_event_id) WHERE (lfs_object_deleted_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_repositories_changed_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_repositories_changed_event_id ON public.geo_event_log USING btree (repositories_changed_event_id) WHERE (repositories_changed_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_repository_created_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_repository_created_event_id ON public.geo_event_log USING btree (repository_created_event_id) WHERE (repository_created_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_repository_deleted_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_repository_deleted_event_id ON public.geo_event_log USING btree (repository_deleted_event_id) WHERE (repository_deleted_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_repository_renamed_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_repository_renamed_event_id ON public.geo_event_log USING btree (repository_renamed_event_id) WHERE (repository_renamed_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_repository_updated_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_repository_updated_event_id ON public.geo_event_log USING btree (repository_updated_event_id) WHERE (repository_updated_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_reset_checksum_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_reset_checksum_event_id ON public.geo_event_log USING btree (reset_checksum_event_id) WHERE (reset_checksum_event_id IS NOT NULL);


--
-- Name: index_geo_event_log_on_upload_deleted_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_event_log_on_upload_deleted_event_id ON public.geo_event_log USING btree (upload_deleted_event_id) WHERE (upload_deleted_event_id IS NOT NULL);


--
-- Name: index_geo_hashed_storage_attachments_events_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_hashed_storage_attachments_events_on_project_id ON public.geo_hashed_storage_attachments_events USING btree (project_id);


--
-- Name: index_geo_hashed_storage_migrated_events_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_hashed_storage_migrated_events_on_project_id ON public.geo_hashed_storage_migrated_events USING btree (project_id);


--
-- Name: index_geo_job_artifact_deleted_events_on_job_artifact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_job_artifact_deleted_events_on_job_artifact_id ON public.geo_job_artifact_deleted_events USING btree (job_artifact_id);


--
-- Name: index_geo_lfs_object_deleted_events_on_lfs_object_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_lfs_object_deleted_events_on_lfs_object_id ON public.geo_lfs_object_deleted_events USING btree (lfs_object_id);


--
-- Name: index_geo_node_namespace_links_on_geo_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_node_namespace_links_on_geo_node_id ON public.geo_node_namespace_links USING btree (geo_node_id);


--
-- Name: index_geo_node_namespace_links_on_geo_node_id_and_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_geo_node_namespace_links_on_geo_node_id_and_namespace_id ON public.geo_node_namespace_links USING btree (geo_node_id, namespace_id);


--
-- Name: index_geo_node_namespace_links_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_node_namespace_links_on_namespace_id ON public.geo_node_namespace_links USING btree (namespace_id);


--
-- Name: index_geo_node_statuses_on_geo_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_geo_node_statuses_on_geo_node_id ON public.geo_node_statuses USING btree (geo_node_id);


--
-- Name: index_geo_nodes_on_access_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_nodes_on_access_key ON public.geo_nodes USING btree (access_key);


--
-- Name: index_geo_nodes_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_geo_nodes_on_name ON public.geo_nodes USING btree (name);


--
-- Name: index_geo_nodes_on_primary; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_nodes_on_primary ON public.geo_nodes USING btree ("primary");


--
-- Name: index_geo_repositories_changed_events_on_geo_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_repositories_changed_events_on_geo_node_id ON public.geo_repositories_changed_events USING btree (geo_node_id);


--
-- Name: index_geo_repository_created_events_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_repository_created_events_on_project_id ON public.geo_repository_created_events USING btree (project_id);


--
-- Name: index_geo_repository_deleted_events_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_repository_deleted_events_on_project_id ON public.geo_repository_deleted_events USING btree (project_id);


--
-- Name: index_geo_repository_renamed_events_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_repository_renamed_events_on_project_id ON public.geo_repository_renamed_events USING btree (project_id);


--
-- Name: index_geo_repository_updated_events_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_repository_updated_events_on_project_id ON public.geo_repository_updated_events USING btree (project_id);


--
-- Name: index_geo_repository_updated_events_on_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_repository_updated_events_on_source ON public.geo_repository_updated_events USING btree (source);


--
-- Name: index_geo_reset_checksum_events_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_reset_checksum_events_on_project_id ON public.geo_reset_checksum_events USING btree (project_id);


--
-- Name: index_geo_upload_deleted_events_on_upload_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geo_upload_deleted_events_on_upload_id ON public.geo_upload_deleted_events USING btree (upload_id);


--
-- Name: index_gitlab_subscriptions_on_hosted_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gitlab_subscriptions_on_hosted_plan_id ON public.gitlab_subscriptions USING btree (hosted_plan_id);


--
-- Name: index_gitlab_subscriptions_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gitlab_subscriptions_on_namespace_id ON public.gitlab_subscriptions USING btree (namespace_id);


--
-- Name: index_gpg_key_subkeys_on_fingerprint; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gpg_key_subkeys_on_fingerprint ON public.gpg_key_subkeys USING btree (fingerprint);


--
-- Name: index_gpg_key_subkeys_on_gpg_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gpg_key_subkeys_on_gpg_key_id ON public.gpg_key_subkeys USING btree (gpg_key_id);


--
-- Name: index_gpg_key_subkeys_on_keyid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gpg_key_subkeys_on_keyid ON public.gpg_key_subkeys USING btree (keyid);


--
-- Name: index_gpg_keys_on_fingerprint; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gpg_keys_on_fingerprint ON public.gpg_keys USING btree (fingerprint);


--
-- Name: index_gpg_keys_on_primary_keyid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gpg_keys_on_primary_keyid ON public.gpg_keys USING btree (primary_keyid);


--
-- Name: index_gpg_keys_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gpg_keys_on_user_id ON public.gpg_keys USING btree (user_id);


--
-- Name: index_gpg_signatures_on_commit_sha; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_gpg_signatures_on_commit_sha ON public.gpg_signatures USING btree (commit_sha);


--
-- Name: index_gpg_signatures_on_gpg_key_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gpg_signatures_on_gpg_key_id ON public.gpg_signatures USING btree (gpg_key_id);


--
-- Name: index_gpg_signatures_on_gpg_key_primary_keyid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gpg_signatures_on_gpg_key_primary_keyid ON public.gpg_signatures USING btree (gpg_key_primary_keyid);


--
-- Name: index_gpg_signatures_on_gpg_key_subkey_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gpg_signatures_on_gpg_key_subkey_id ON public.gpg_signatures USING btree (gpg_key_subkey_id);


--
-- Name: index_gpg_signatures_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_gpg_signatures_on_project_id ON public.gpg_signatures USING btree (project_id);


--
-- Name: index_group_custom_attributes_on_group_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_group_custom_attributes_on_group_id_and_key ON public.group_custom_attributes USING btree (group_id, key);


--
-- Name: index_group_custom_attributes_on_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_group_custom_attributes_on_key_and_value ON public.group_custom_attributes USING btree (key, value);


--
-- Name: index_identities_on_saml_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_saml_provider_id ON public.identities USING btree (saml_provider_id) WHERE (saml_provider_id IS NOT NULL);


--
-- Name: index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_user_id ON public.identities USING btree (user_id);


--
-- Name: index_import_export_uploads_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_import_export_uploads_on_project_id ON public.import_export_uploads USING btree (project_id);


--
-- Name: index_import_export_uploads_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_import_export_uploads_on_updated_at ON public.import_export_uploads USING btree (updated_at);


--
-- Name: index_index_statuses_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_index_statuses_on_project_id ON public.index_statuses USING btree (project_id);


--
-- Name: index_insights_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_insights_on_namespace_id ON public.insights USING btree (namespace_id);


--
-- Name: index_insights_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_insights_on_project_id ON public.insights USING btree (project_id);


--
-- Name: index_internal_ids_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_internal_ids_on_namespace_id ON public.internal_ids USING btree (namespace_id);


--
-- Name: index_internal_ids_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_internal_ids_on_project_id ON public.internal_ids USING btree (project_id);


--
-- Name: index_internal_ids_on_usage_and_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_internal_ids_on_usage_and_namespace_id ON public.internal_ids USING btree (usage, namespace_id) WHERE (namespace_id IS NOT NULL);


--
-- Name: index_internal_ids_on_usage_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_internal_ids_on_usage_and_project_id ON public.internal_ids USING btree (usage, project_id) WHERE (project_id IS NOT NULL);


--
-- Name: index_ip_restrictions_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ip_restrictions_on_group_id ON public.ip_restrictions USING btree (group_id);


--
-- Name: index_issue_assignees_on_issue_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_issue_assignees_on_issue_id_and_user_id ON public.issue_assignees USING btree (issue_id, user_id);


--
-- Name: index_issue_assignees_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_assignees_on_user_id ON public.issue_assignees USING btree (user_id);


--
-- Name: index_issue_links_on_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_links_on_source_id ON public.issue_links USING btree (source_id);


--
-- Name: index_issue_links_on_source_id_and_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_issue_links_on_source_id_and_target_id ON public.issue_links USING btree (source_id, target_id);


--
-- Name: index_issue_links_on_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_links_on_target_id ON public.issue_links USING btree (target_id);


--
-- Name: index_issue_metrics; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_metrics ON public.issue_metrics USING btree (issue_id);


--
-- Name: index_issue_tracker_data_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issue_tracker_data_on_service_id ON public.issue_tracker_data USING btree (service_id);


--
-- Name: index_issues_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_author_id ON public.issues USING btree (author_id);


--
-- Name: index_issues_on_closed_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_closed_by_id ON public.issues USING btree (closed_by_id);


--
-- Name: index_issues_on_confidential; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_confidential ON public.issues USING btree (confidential);


--
-- Name: index_issues_on_description_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_description_trigram ON public.issues USING gin (description public.gin_trgm_ops);


--
-- Name: index_issues_on_milestone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_milestone_id ON public.issues USING btree (milestone_id);


--
-- Name: index_issues_on_moved_to_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_moved_to_id ON public.issues USING btree (moved_to_id) WHERE (moved_to_id IS NOT NULL);


--
-- Name: index_issues_on_project_id_and_created_at_and_id_and_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_project_id_and_created_at_and_id_and_state ON public.issues USING btree (project_id, created_at, id, state);


--
-- Name: index_issues_on_project_id_and_iid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_issues_on_project_id_and_iid ON public.issues USING btree (project_id, iid);


--
-- Name: index_issues_on_project_id_and_updated_at_and_id_and_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_project_id_and_updated_at_and_id_and_state ON public.issues USING btree (project_id, updated_at, id, state);


--
-- Name: index_issues_on_relative_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_relative_position ON public.issues USING btree (relative_position);


--
-- Name: index_issues_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_state ON public.issues USING btree (state);


--
-- Name: index_issues_on_title_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_title_trigram ON public.issues USING gin (title public.gin_trgm_ops);


--
-- Name: index_issues_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_updated_at ON public.issues USING btree (updated_at);


--
-- Name: index_issues_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_issues_on_updated_by_id ON public.issues USING btree (updated_by_id) WHERE (updated_by_id IS NOT NULL);


--
-- Name: index_jira_connect_installations_on_client_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_jira_connect_installations_on_client_key ON public.jira_connect_installations USING btree (client_key);


--
-- Name: index_jira_connect_subscriptions_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jira_connect_subscriptions_on_namespace_id ON public.jira_connect_subscriptions USING btree (namespace_id);


--
-- Name: index_jira_tracker_data_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jira_tracker_data_on_service_id ON public.jira_tracker_data USING btree (service_id);


--
-- Name: index_keys_on_fingerprint; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_keys_on_fingerprint ON public.keys USING btree (fingerprint);


--
-- Name: index_keys_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_keys_on_user_id ON public.keys USING btree (user_id);


--
-- Name: index_label_links_on_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_label_links_on_label_id ON public.label_links USING btree (label_id);


--
-- Name: index_label_links_on_target_id_and_target_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_label_links_on_target_id_and_target_type ON public.label_links USING btree (target_id, target_type);


--
-- Name: index_label_priorities_on_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_label_priorities_on_label_id ON public.label_priorities USING btree (label_id);


--
-- Name: index_label_priorities_on_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_label_priorities_on_priority ON public.label_priorities USING btree (priority);


--
-- Name: index_label_priorities_on_project_id_and_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_label_priorities_on_project_id_and_label_id ON public.label_priorities USING btree (project_id, label_id);


--
-- Name: index_labels_on_group_id_and_project_id_and_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_labels_on_group_id_and_project_id_and_title ON public.labels USING btree (group_id, project_id, title);


--
-- Name: index_labels_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labels_on_project_id ON public.labels USING btree (project_id);


--
-- Name: index_labels_on_template; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labels_on_template ON public.labels USING btree (template) WHERE template;


--
-- Name: index_labels_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labels_on_title ON public.labels USING btree (title);


--
-- Name: index_labels_on_type_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labels_on_type_and_project_id ON public.labels USING btree (type, project_id);


--
-- Name: index_lfs_file_locks_on_project_id_and_path; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lfs_file_locks_on_project_id_and_path ON public.lfs_file_locks USING btree (project_id, path);


--
-- Name: index_lfs_file_locks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lfs_file_locks_on_user_id ON public.lfs_file_locks USING btree (user_id);


--
-- Name: index_lfs_objects_on_file_store; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lfs_objects_on_file_store ON public.lfs_objects USING btree (file_store);


--
-- Name: index_lfs_objects_on_oid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lfs_objects_on_oid ON public.lfs_objects USING btree (oid);


--
-- Name: index_lfs_objects_projects_on_lfs_object_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lfs_objects_projects_on_lfs_object_id ON public.lfs_objects_projects USING btree (lfs_object_id);


--
-- Name: index_lfs_objects_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lfs_objects_projects_on_project_id ON public.lfs_objects_projects USING btree (project_id);


--
-- Name: index_lists_on_board_id_and_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_lists_on_board_id_and_label_id ON public.lists USING btree (board_id, label_id);


--
-- Name: index_lists_on_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_label_id ON public.lists USING btree (label_id);


--
-- Name: index_lists_on_list_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_list_type ON public.lists USING btree (list_type);


--
-- Name: index_lists_on_milestone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_milestone_id ON public.lists USING btree (milestone_id);


--
-- Name: index_lists_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_lists_on_user_id ON public.lists USING btree (user_id);


--
-- Name: index_members_on_access_level; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_access_level ON public.members USING btree (access_level);


--
-- Name: index_members_on_invite_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_invite_email ON public.members USING btree (invite_email);


--
-- Name: index_members_on_invite_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_members_on_invite_token ON public.members USING btree (invite_token);


--
-- Name: index_members_on_requested_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_requested_at ON public.members USING btree (requested_at);


--
-- Name: index_members_on_source_id_and_source_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_source_id_and_source_type ON public.members USING btree (source_id, source_type);


--
-- Name: index_members_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_members_on_user_id ON public.members USING btree (user_id);


--
-- Name: index_merge_request_assignees_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_assignees_on_merge_request_id ON public.merge_request_assignees USING btree (merge_request_id);


--
-- Name: index_merge_request_assignees_on_merge_request_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_merge_request_assignees_on_merge_request_id_and_user_id ON public.merge_request_assignees USING btree (merge_request_id, user_id);


--
-- Name: index_merge_request_assignees_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_assignees_on_user_id ON public.merge_request_assignees USING btree (user_id);


--
-- Name: index_merge_request_blocks_on_blocked_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_blocks_on_blocked_merge_request_id ON public.merge_request_blocks USING btree (blocked_merge_request_id);


--
-- Name: index_merge_request_diff_commits_on_mr_diff_id_and_order; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_merge_request_diff_commits_on_mr_diff_id_and_order ON public.merge_request_diff_commits USING btree (merge_request_diff_id, relative_order);


--
-- Name: index_merge_request_diff_commits_on_sha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_diff_commits_on_sha ON public.merge_request_diff_commits USING btree (sha);


--
-- Name: index_merge_request_diff_files_on_mr_diff_id_and_order; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_merge_request_diff_files_on_mr_diff_id_and_order ON public.merge_request_diff_files USING btree (merge_request_diff_id, relative_order);


--
-- Name: index_merge_request_diffs_on_merge_request_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_diffs_on_merge_request_id_and_id ON public.merge_request_diffs USING btree (merge_request_id, id);


--
-- Name: index_merge_request_diffs_on_merge_request_id_and_id_partial; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_diffs_on_merge_request_id_and_id_partial ON public.merge_request_diffs USING btree (merge_request_id, id) WHERE ((NOT stored_externally) OR (stored_externally IS NULL));


--
-- Name: index_merge_request_metrics; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_metrics ON public.merge_request_metrics USING btree (merge_request_id);


--
-- Name: index_merge_request_metrics_on_first_deployed_to_production_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_metrics_on_first_deployed_to_production_at ON public.merge_request_metrics USING btree (first_deployed_to_production_at);


--
-- Name: index_merge_request_metrics_on_latest_closed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_metrics_on_latest_closed_at ON public.merge_request_metrics USING btree (latest_closed_at) WHERE (latest_closed_at IS NOT NULL);


--
-- Name: index_merge_request_metrics_on_latest_closed_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_metrics_on_latest_closed_by_id ON public.merge_request_metrics USING btree (latest_closed_by_id);


--
-- Name: index_merge_request_metrics_on_merge_request_id_and_merged_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_metrics_on_merge_request_id_and_merged_at ON public.merge_request_metrics USING btree (merge_request_id, merged_at) WHERE (merged_at IS NOT NULL);


--
-- Name: index_merge_request_metrics_on_merged_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_metrics_on_merged_by_id ON public.merge_request_metrics USING btree (merged_by_id);


--
-- Name: index_merge_request_metrics_on_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_request_metrics_on_pipeline_id ON public.merge_request_metrics USING btree (pipeline_id);


--
-- Name: index_merge_requests_closing_issues_on_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_closing_issues_on_issue_id ON public.merge_requests_closing_issues USING btree (issue_id);


--
-- Name: index_merge_requests_closing_issues_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_closing_issues_on_merge_request_id ON public.merge_requests_closing_issues USING btree (merge_request_id);


--
-- Name: index_merge_requests_on_assignee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_assignee_id ON public.merge_requests USING btree (assignee_id);


--
-- Name: index_merge_requests_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_author_id ON public.merge_requests USING btree (author_id);


--
-- Name: index_merge_requests_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_created_at ON public.merge_requests USING btree (created_at);


--
-- Name: index_merge_requests_on_description_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_description_trigram ON public.merge_requests USING gin (description public.gin_trgm_ops);


--
-- Name: index_merge_requests_on_head_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_head_pipeline_id ON public.merge_requests USING btree (head_pipeline_id);


--
-- Name: index_merge_requests_on_id_and_merge_jid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_id_and_merge_jid ON public.merge_requests USING btree (id, merge_jid) WHERE ((merge_jid IS NOT NULL) AND ((state)::text = 'locked'::text));


--
-- Name: index_merge_requests_on_latest_merge_request_diff_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_latest_merge_request_diff_id ON public.merge_requests USING btree (latest_merge_request_diff_id);


--
-- Name: index_merge_requests_on_merge_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_merge_user_id ON public.merge_requests USING btree (merge_user_id) WHERE (merge_user_id IS NOT NULL);


--
-- Name: index_merge_requests_on_milestone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_milestone_id ON public.merge_requests USING btree (milestone_id);


--
-- Name: index_merge_requests_on_source_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_source_branch ON public.merge_requests USING btree (source_branch);


--
-- Name: index_merge_requests_on_source_project_and_branch_state_opened; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_source_project_and_branch_state_opened ON public.merge_requests USING btree (source_project_id, source_branch) WHERE ((state)::text = 'opened'::text);


--
-- Name: index_merge_requests_on_source_project_id_and_source_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_source_project_id_and_source_branch ON public.merge_requests USING btree (source_project_id, source_branch);


--
-- Name: index_merge_requests_on_state_and_merge_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_state_and_merge_status ON public.merge_requests USING btree (state, merge_status) WHERE (((state)::text = 'opened'::text) AND ((merge_status)::text = 'can_be_merged'::text));


--
-- Name: index_merge_requests_on_target_branch; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_target_branch ON public.merge_requests USING btree (target_branch);


--
-- Name: index_merge_requests_on_target_project_id_and_iid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_merge_requests_on_target_project_id_and_iid ON public.merge_requests USING btree (target_project_id, iid);


--
-- Name: index_merge_requests_on_target_project_id_and_iid_opened; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_target_project_id_and_iid_opened ON public.merge_requests USING btree (target_project_id, iid) WHERE ((state)::text = 'opened'::text);


--
-- Name: index_merge_requests_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_title ON public.merge_requests USING btree (title);


--
-- Name: index_merge_requests_on_title_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_title_trigram ON public.merge_requests USING gin (title public.gin_trgm_ops);


--
-- Name: index_merge_requests_on_tp_id_and_merge_commit_sha_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_tp_id_and_merge_commit_sha_and_id ON public.merge_requests USING btree (target_project_id, merge_commit_sha, id);


--
-- Name: index_merge_requests_on_updated_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_requests_on_updated_by_id ON public.merge_requests USING btree (updated_by_id) WHERE (updated_by_id IS NOT NULL);


--
-- Name: index_merge_trains_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_merge_trains_on_merge_request_id ON public.merge_trains USING btree (merge_request_id);


--
-- Name: index_merge_trains_on_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_trains_on_pipeline_id ON public.merge_trains USING btree (pipeline_id);


--
-- Name: index_merge_trains_on_target_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_trains_on_target_project_id ON public.merge_trains USING btree (target_project_id);


--
-- Name: index_merge_trains_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_trains_on_user_id ON public.merge_trains USING btree (user_id);


--
-- Name: index_milestone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_milestone ON public.epics USING btree (milestone_id);


--
-- Name: index_milestones_on_description_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_milestones_on_description_trigram ON public.milestones USING gin (description public.gin_trgm_ops);


--
-- Name: index_milestones_on_due_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_milestones_on_due_date ON public.milestones USING btree (due_date);


--
-- Name: index_milestones_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_milestones_on_group_id ON public.milestones USING btree (group_id);


--
-- Name: index_milestones_on_project_id_and_iid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_milestones_on_project_id_and_iid ON public.milestones USING btree (project_id, iid);


--
-- Name: index_milestones_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_milestones_on_title ON public.milestones USING btree (title);


--
-- Name: index_milestones_on_title_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_milestones_on_title_trigram ON public.milestones USING gin (title public.gin_trgm_ops);


--
-- Name: index_mirror_data_on_next_execution_and_retry_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mirror_data_on_next_execution_and_retry_count ON public.project_mirror_data USING btree (next_execution_timestamp, retry_count);


--
-- Name: index_mr_blocks_on_blocking_and_blocked_mr_ids; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_mr_blocks_on_blocking_and_blocked_mr_ids ON public.merge_request_blocks USING btree (blocking_merge_request_id, blocked_merge_request_id);


--
-- Name: index_namespace_aggregation_schedules_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespace_aggregation_schedules_on_namespace_id ON public.namespace_aggregation_schedules USING btree (namespace_id);


--
-- Name: index_namespace_root_storage_statistics_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespace_root_storage_statistics_on_namespace_id ON public.namespace_root_storage_statistics USING btree (namespace_id);


--
-- Name: index_namespace_statistics_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespace_statistics_on_namespace_id ON public.namespace_statistics USING btree (namespace_id);


--
-- Name: index_namespaces_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_created_at ON public.namespaces USING btree (created_at);


--
-- Name: index_namespaces_on_custom_project_templates_group_id_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_custom_project_templates_group_id_and_type ON public.namespaces USING btree (custom_project_templates_group_id, type) WHERE (custom_project_templates_group_id IS NOT NULL);


--
-- Name: index_namespaces_on_file_template_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_file_template_project_id ON public.namespaces USING btree (file_template_project_id);


--
-- Name: index_namespaces_on_ldap_sync_last_successful_update_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_ldap_sync_last_successful_update_at ON public.namespaces USING btree (ldap_sync_last_successful_update_at);


--
-- Name: index_namespaces_on_ldap_sync_last_update_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_ldap_sync_last_update_at ON public.namespaces USING btree (ldap_sync_last_update_at);


--
-- Name: index_namespaces_on_name_and_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespaces_on_name_and_parent_id ON public.namespaces USING btree (name, parent_id);


--
-- Name: index_namespaces_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_name_trigram ON public.namespaces USING gin (name public.gin_trgm_ops);


--
-- Name: index_namespaces_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_owner_id ON public.namespaces USING btree (owner_id);


--
-- Name: index_namespaces_on_parent_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespaces_on_parent_id_and_id ON public.namespaces USING btree (parent_id, id);


--
-- Name: index_namespaces_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_path ON public.namespaces USING btree (path);


--
-- Name: index_namespaces_on_path_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_path_trigram ON public.namespaces USING gin (path public.gin_trgm_ops);


--
-- Name: index_namespaces_on_plan_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_plan_id ON public.namespaces USING btree (plan_id);


--
-- Name: index_namespaces_on_require_two_factor_authentication; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_require_two_factor_authentication ON public.namespaces USING btree (require_two_factor_authentication);


--
-- Name: index_namespaces_on_runners_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespaces_on_runners_token ON public.namespaces USING btree (runners_token);


--
-- Name: index_namespaces_on_runners_token_encrypted; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespaces_on_runners_token_encrypted ON public.namespaces USING btree (runners_token_encrypted);


--
-- Name: index_namespaces_on_shared_and_extra_runners_minutes_limit; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_shared_and_extra_runners_minutes_limit ON public.namespaces USING btree (shared_runners_minutes_limit, extra_shared_runners_minutes_limit);


--
-- Name: index_namespaces_on_trial_ends_on; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_trial_ends_on ON public.namespaces USING btree (trial_ends_on) WHERE (trial_ends_on IS NOT NULL);


--
-- Name: index_namespaces_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespaces_on_type ON public.namespaces USING btree (type);


--
-- Name: index_note_diff_files_on_diff_note_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_note_diff_files_on_diff_note_id ON public.note_diff_files USING btree (diff_note_id);


--
-- Name: index_notes_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_author_id ON public.notes USING btree (author_id);


--
-- Name: index_notes_on_commit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_commit_id ON public.notes USING btree (commit_id);


--
-- Name: index_notes_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_created_at ON public.notes USING btree (created_at);


--
-- Name: index_notes_on_discussion_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_discussion_id ON public.notes USING btree (discussion_id);


--
-- Name: index_notes_on_line_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_line_code ON public.notes USING btree (line_code);


--
-- Name: index_notes_on_note_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_note_trigram ON public.notes USING gin (note public.gin_trgm_ops);


--
-- Name: index_notes_on_noteable_id_and_noteable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_noteable_id_and_noteable_type ON public.notes USING btree (noteable_id, noteable_type);


--
-- Name: index_notes_on_noteable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_noteable_type ON public.notes USING btree (noteable_type);


--
-- Name: index_notes_on_project_id_and_noteable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_project_id_and_noteable_type ON public.notes USING btree (project_id, noteable_type);


--
-- Name: index_notes_on_review_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notes_on_review_id ON public.notes USING btree (review_id);


--
-- Name: index_notification_settings_on_source_id_and_source_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notification_settings_on_source_id_and_source_type ON public.notification_settings USING btree (source_id, source_type);


--
-- Name: index_notification_settings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notification_settings_on_user_id ON public.notification_settings USING btree (user_id);


--
-- Name: index_notifications_on_user_id_and_source_id_and_source_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_notifications_on_user_id_and_source_id_and_source_type ON public.notification_settings USING btree (user_id, source_id, source_type);


--
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON public.oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON public.oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON public.oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON public.oauth_access_tokens USING btree (token);


--
-- Name: index_oauth_applications_on_owner_id_and_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON public.oauth_applications USING btree (owner_id, owner_type);


--
-- Name: index_oauth_applications_on_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_oauth_applications_on_uid ON public.oauth_applications USING btree (uid);


--
-- Name: index_oauth_openid_requests_on_access_grant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_openid_requests_on_access_grant_id ON public.oauth_openid_requests USING btree (access_grant_id);


--
-- Name: index_operations_feature_flags_clients_on_project_id_and_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_operations_feature_flags_clients_on_project_id_and_token ON public.operations_feature_flags_clients USING btree (project_id, token);


--
-- Name: index_operations_feature_flags_on_project_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_operations_feature_flags_on_project_id_and_name ON public.operations_feature_flags USING btree (project_id, name);


--
-- Name: index_packages_maven_metadata_on_package_id_and_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_packages_maven_metadata_on_package_id_and_path ON public.packages_maven_metadata USING btree (package_id, path);


--
-- Name: index_packages_package_files_on_package_id_and_file_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_packages_package_files_on_package_id_and_file_name ON public.packages_package_files USING btree (package_id, file_name);


--
-- Name: index_packages_packages_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_packages_packages_on_project_id ON public.packages_packages USING btree (project_id);


--
-- Name: index_pages_domain_acme_orders_on_challenge_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_domain_acme_orders_on_challenge_token ON public.pages_domain_acme_orders USING btree (challenge_token);


--
-- Name: index_pages_domain_acme_orders_on_pages_domain_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_domain_acme_orders_on_pages_domain_id ON public.pages_domain_acme_orders USING btree (pages_domain_id);


--
-- Name: index_pages_domains_need_auto_ssl_renewal; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_domains_need_auto_ssl_renewal ON public.pages_domains USING btree (certificate_source, certificate_valid_not_after) WHERE (auto_ssl_enabled = true);


--
-- Name: index_pages_domains_on_domain; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pages_domains_on_domain ON public.pages_domains USING btree (domain);


--
-- Name: index_pages_domains_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_domains_on_project_id ON public.pages_domains USING btree (project_id);


--
-- Name: index_pages_domains_on_project_id_and_enabled_until; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_domains_on_project_id_and_enabled_until ON public.pages_domains USING btree (project_id, enabled_until);


--
-- Name: index_pages_domains_on_remove_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_domains_on_remove_at ON public.pages_domains USING btree (remove_at);


--
-- Name: index_pages_domains_on_verified_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_domains_on_verified_at ON public.pages_domains USING btree (verified_at);


--
-- Name: index_pages_domains_on_verified_at_and_enabled_until; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pages_domains_on_verified_at_and_enabled_until ON public.pages_domains USING btree (verified_at, enabled_until);


--
-- Name: index_path_locks_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_path_locks_on_path ON public.path_locks USING btree (path);


--
-- Name: index_path_locks_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_path_locks_on_project_id ON public.path_locks USING btree (project_id);


--
-- Name: index_path_locks_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_path_locks_on_user_id ON public.path_locks USING btree (user_id);


--
-- Name: index_personal_access_tokens_on_token_digest; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_personal_access_tokens_on_token_digest ON public.personal_access_tokens USING btree (token_digest);


--
-- Name: index_personal_access_tokens_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_personal_access_tokens_on_user_id ON public.personal_access_tokens USING btree (user_id);


--
-- Name: index_plans_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_plans_on_name ON public.plans USING btree (name);


--
-- Name: index_pool_repositories_on_disk_path; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pool_repositories_on_disk_path ON public.pool_repositories USING btree (disk_path);


--
-- Name: index_pool_repositories_on_shard_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pool_repositories_on_shard_id ON public.pool_repositories USING btree (shard_id);


--
-- Name: index_pool_repositories_on_source_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pool_repositories_on_source_project_id ON public.pool_repositories USING btree (source_project_id);


--
-- Name: index_programming_languages_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_programming_languages_on_name ON public.programming_languages USING btree (name);


--
-- Name: index_project_aliases_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_aliases_on_name ON public.project_aliases USING btree (name);


--
-- Name: index_project_aliases_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_aliases_on_project_id ON public.project_aliases USING btree (project_id);


--
-- Name: index_project_authorizations_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_authorizations_on_project_id ON public.project_authorizations USING btree (project_id);


--
-- Name: index_project_authorizations_on_user_id_project_id_access_level; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_authorizations_on_user_id_project_id_access_level ON public.project_authorizations USING btree (user_id, project_id, access_level);


--
-- Name: index_project_auto_devops_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_auto_devops_on_project_id ON public.project_auto_devops USING btree (project_id);


--
-- Name: index_project_ci_cd_settings_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_ci_cd_settings_on_project_id ON public.project_ci_cd_settings USING btree (project_id);


--
-- Name: index_project_custom_attributes_on_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_custom_attributes_on_key_and_value ON public.project_custom_attributes USING btree (key, value);


--
-- Name: index_project_custom_attributes_on_project_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_custom_attributes_on_project_id_and_key ON public.project_custom_attributes USING btree (project_id, key);


--
-- Name: index_project_daily_statistics_on_project_id_and_date; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_daily_statistics_on_project_id_and_date ON public.project_daily_statistics USING btree (project_id, date DESC);


--
-- Name: index_project_deploy_tokens_on_deploy_token_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_deploy_tokens_on_deploy_token_id ON public.project_deploy_tokens USING btree (deploy_token_id);


--
-- Name: index_project_deploy_tokens_on_project_id_and_deploy_token_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_deploy_tokens_on_project_id_and_deploy_token_id ON public.project_deploy_tokens USING btree (project_id, deploy_token_id);


--
-- Name: index_project_feature_usages_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_feature_usages_on_project_id ON public.project_feature_usages USING btree (project_id);


--
-- Name: index_project_features_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_features_on_project_id ON public.project_features USING btree (project_id);


--
-- Name: index_project_group_links_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_group_links_on_group_id ON public.project_group_links USING btree (group_id);


--
-- Name: index_project_group_links_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_group_links_on_project_id ON public.project_group_links USING btree (project_id);


--
-- Name: index_project_import_data_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_import_data_on_project_id ON public.project_import_data USING btree (project_id);


--
-- Name: index_project_mirror_data_on_jid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_mirror_data_on_jid ON public.project_mirror_data USING btree (jid);


--
-- Name: index_project_mirror_data_on_last_successful_update_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_mirror_data_on_last_successful_update_at ON public.project_mirror_data USING btree (last_successful_update_at);


--
-- Name: index_project_mirror_data_on_last_update_at_and_retry_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_mirror_data_on_last_update_at_and_retry_count ON public.project_mirror_data USING btree (last_update_at, retry_count);


--
-- Name: index_project_mirror_data_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_mirror_data_on_project_id ON public.project_mirror_data USING btree (project_id);


--
-- Name: index_project_mirror_data_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_mirror_data_on_status ON public.project_mirror_data USING btree (status);


--
-- Name: index_project_repositories_on_disk_path; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_repositories_on_disk_path ON public.project_repositories USING btree (disk_path);


--
-- Name: index_project_repositories_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_repositories_on_project_id ON public.project_repositories USING btree (project_id);


--
-- Name: index_project_repositories_on_shard_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_repositories_on_shard_id ON public.project_repositories USING btree (shard_id);


--
-- Name: index_project_repository_states_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_repository_states_on_project_id ON public.project_repository_states USING btree (project_id);


--
-- Name: index_project_statistics_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_statistics_on_namespace_id ON public.project_statistics USING btree (namespace_id);


--
-- Name: index_project_statistics_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_statistics_on_project_id ON public.project_statistics USING btree (project_id);


--
-- Name: index_project_tracing_settings_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_project_tracing_settings_on_project_id ON public.project_tracing_settings USING btree (project_id);


--
-- Name: index_projects_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_created_at ON public.projects USING btree (created_at);


--
-- Name: index_projects_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_creator_id ON public.projects USING btree (creator_id);


--
-- Name: index_projects_on_description_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_description_trigram ON public.projects USING gin (description public.gin_trgm_ops);


--
-- Name: index_projects_on_id_partial_for_visibility; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_projects_on_id_partial_for_visibility ON public.projects USING btree (id) WHERE (visibility_level = ANY (ARRAY[10, 20]));


--
-- Name: index_projects_on_last_activity_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_last_activity_at ON public.projects USING btree (last_activity_at);


--
-- Name: index_projects_on_last_repository_check_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_last_repository_check_at ON public.projects USING btree (last_repository_check_at) WHERE (last_repository_check_at IS NOT NULL);


--
-- Name: index_projects_on_last_repository_check_failed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_last_repository_check_failed ON public.projects USING btree (last_repository_check_failed);


--
-- Name: index_projects_on_last_repository_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_last_repository_updated_at ON public.projects USING btree (last_repository_updated_at);


--
-- Name: index_projects_on_mirror_and_mirror_trigger_builds_both_true; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_mirror_and_mirror_trigger_builds_both_true ON public.projects USING btree (id) WHERE ((mirror IS TRUE) AND (mirror_trigger_builds IS TRUE));


--
-- Name: index_projects_on_mirror_last_successful_update_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_mirror_last_successful_update_at ON public.projects USING btree (mirror_last_successful_update_at);


--
-- Name: index_projects_on_mirror_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_mirror_user_id ON public.projects USING btree (mirror_user_id);


--
-- Name: index_projects_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_name_trigram ON public.projects USING gin (name public.gin_trgm_ops);


--
-- Name: index_projects_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_namespace_id ON public.projects USING btree (namespace_id);


--
-- Name: index_projects_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_path ON public.projects USING btree (path);


--
-- Name: index_projects_on_path_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_path_trigram ON public.projects USING gin (path public.gin_trgm_ops);


--
-- Name: index_projects_on_pending_delete; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_pending_delete ON public.projects USING btree (pending_delete);


--
-- Name: index_projects_on_pool_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_pool_repository_id ON public.projects USING btree (pool_repository_id) WHERE (pool_repository_id IS NOT NULL);


--
-- Name: index_projects_on_repository_storage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_repository_storage ON public.projects USING btree (repository_storage);


--
-- Name: index_projects_on_runners_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_runners_token ON public.projects USING btree (runners_token);


--
-- Name: index_projects_on_runners_token_encrypted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_runners_token_encrypted ON public.projects USING btree (runners_token_encrypted);


--
-- Name: index_projects_on_star_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_star_count ON public.projects USING btree (star_count);


--
-- Name: index_projects_on_visibility_level; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_visibility_level ON public.projects USING btree (visibility_level);


--
-- Name: index_prometheus_alert_event_scoped_payload_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_prometheus_alert_event_scoped_payload_key ON public.prometheus_alert_events USING btree (prometheus_alert_id, payload_key);


--
-- Name: index_prometheus_alert_events_on_project_id_and_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prometheus_alert_events_on_project_id_and_status ON public.prometheus_alert_events USING btree (project_id, status);


--
-- Name: index_prometheus_alerts_metric_environment; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_prometheus_alerts_metric_environment ON public.prometheus_alerts USING btree (project_id, prometheus_metric_id, environment_id);


--
-- Name: index_prometheus_alerts_on_environment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prometheus_alerts_on_environment_id ON public.prometheus_alerts USING btree (environment_id);


--
-- Name: index_prometheus_alerts_on_prometheus_metric_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prometheus_alerts_on_prometheus_metric_id ON public.prometheus_alerts USING btree (prometheus_metric_id);


--
-- Name: index_prometheus_metrics_on_common; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prometheus_metrics_on_common ON public.prometheus_metrics USING btree (common);


--
-- Name: index_prometheus_metrics_on_group; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prometheus_metrics_on_group ON public.prometheus_metrics USING btree ("group");


--
-- Name: index_prometheus_metrics_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_prometheus_metrics_on_identifier ON public.prometheus_metrics USING btree (identifier);


--
-- Name: index_prometheus_metrics_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_prometheus_metrics_on_project_id ON public.prometheus_metrics USING btree (project_id);


--
-- Name: index_protected_branch_merge_access; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_merge_access ON public.protected_branch_merge_access_levels USING btree (protected_branch_id);


--
-- Name: index_protected_branch_merge_access_levels_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_merge_access_levels_on_group_id ON public.protected_branch_merge_access_levels USING btree (group_id);


--
-- Name: index_protected_branch_merge_access_levels_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_merge_access_levels_on_user_id ON public.protected_branch_merge_access_levels USING btree (user_id);


--
-- Name: index_protected_branch_push_access; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_push_access ON public.protected_branch_push_access_levels USING btree (protected_branch_id);


--
-- Name: index_protected_branch_push_access_levels_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_push_access_levels_on_group_id ON public.protected_branch_push_access_levels USING btree (group_id);


--
-- Name: index_protected_branch_push_access_levels_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_push_access_levels_on_user_id ON public.protected_branch_push_access_levels USING btree (user_id);


--
-- Name: index_protected_branch_unprotect_access; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_unprotect_access ON public.protected_branch_unprotect_access_levels USING btree (protected_branch_id);


--
-- Name: index_protected_branch_unprotect_access_levels_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_unprotect_access_levels_on_group_id ON public.protected_branch_unprotect_access_levels USING btree (group_id);


--
-- Name: index_protected_branch_unprotect_access_levels_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branch_unprotect_access_levels_on_user_id ON public.protected_branch_unprotect_access_levels USING btree (user_id);


--
-- Name: index_protected_branches_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_branches_on_project_id ON public.protected_branches USING btree (project_id);


--
-- Name: index_protected_environment_deploy_access; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_environment_deploy_access ON public.protected_environment_deploy_access_levels USING btree (protected_environment_id);


--
-- Name: index_protected_environment_deploy_access_levels_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_environment_deploy_access_levels_on_group_id ON public.protected_environment_deploy_access_levels USING btree (group_id);


--
-- Name: index_protected_environment_deploy_access_levels_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_environment_deploy_access_levels_on_user_id ON public.protected_environment_deploy_access_levels USING btree (user_id);


--
-- Name: index_protected_environments_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_environments_on_project_id ON public.protected_environments USING btree (project_id);


--
-- Name: index_protected_environments_on_project_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_protected_environments_on_project_id_and_name ON public.protected_environments USING btree (project_id, name);


--
-- Name: index_protected_tag_create_access; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_tag_create_access ON public.protected_tag_create_access_levels USING btree (protected_tag_id);


--
-- Name: index_protected_tag_create_access_levels_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_tag_create_access_levels_on_group_id ON public.protected_tag_create_access_levels USING btree (group_id);


--
-- Name: index_protected_tag_create_access_levels_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_tag_create_access_levels_on_user_id ON public.protected_tag_create_access_levels USING btree (user_id);


--
-- Name: index_protected_tags_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_protected_tags_on_project_id ON public.protected_tags USING btree (project_id);


--
-- Name: index_protected_tags_on_project_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_protected_tags_on_project_id_and_name ON public.protected_tags USING btree (project_id, name);


--
-- Name: index_push_event_payloads_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_push_event_payloads_on_event_id ON public.push_event_payloads USING btree (event_id);


--
-- Name: index_push_rules_on_is_sample; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_push_rules_on_is_sample ON public.push_rules USING btree (is_sample) WHERE is_sample;


--
-- Name: index_push_rules_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_push_rules_on_project_id ON public.push_rules USING btree (project_id);


--
-- Name: index_redirect_routes_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_redirect_routes_on_path ON public.redirect_routes USING btree (path);


--
-- Name: index_redirect_routes_on_source_type_and_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_redirect_routes_on_source_type_and_source_id ON public.redirect_routes USING btree (source_type, source_id);


--
-- Name: index_release_links_on_release_id_and_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_release_links_on_release_id_and_name ON public.release_links USING btree (release_id, name);


--
-- Name: index_release_links_on_release_id_and_url; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_release_links_on_release_id_and_url ON public.release_links USING btree (release_id, url);


--
-- Name: index_releases_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_releases_on_author_id ON public.releases USING btree (author_id);


--
-- Name: index_releases_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_releases_on_project_id ON public.releases USING btree (project_id);


--
-- Name: index_releases_on_project_id_and_tag; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_releases_on_project_id_and_tag ON public.releases USING btree (project_id, tag);


--
-- Name: index_remote_mirrors_on_last_successful_update_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_remote_mirrors_on_last_successful_update_at ON public.remote_mirrors USING btree (last_successful_update_at);


--
-- Name: index_remote_mirrors_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_remote_mirrors_on_project_id ON public.remote_mirrors USING btree (project_id);


--
-- Name: index_repository_languages_on_project_and_languages_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_repository_languages_on_project_and_languages_id ON public.repository_languages USING btree (project_id, programming_language_id);


--
-- Name: index_resource_label_events_on_epic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_label_events_on_epic_id ON public.resource_label_events USING btree (epic_id);


--
-- Name: index_resource_label_events_on_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_label_events_on_issue_id ON public.resource_label_events USING btree (issue_id);


--
-- Name: index_resource_label_events_on_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_label_events_on_label_id ON public.resource_label_events USING btree (label_id);


--
-- Name: index_resource_label_events_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_label_events_on_merge_request_id ON public.resource_label_events USING btree (merge_request_id);


--
-- Name: index_resource_label_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_resource_label_events_on_user_id ON public.resource_label_events USING btree (user_id);


--
-- Name: index_reviews_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_author_id ON public.reviews USING btree (author_id);


--
-- Name: index_reviews_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_merge_request_id ON public.reviews USING btree (merge_request_id);


--
-- Name: index_reviews_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_project_id ON public.reviews USING btree (project_id);


--
-- Name: index_routes_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_routes_on_path ON public.routes USING btree (path);


--
-- Name: index_routes_on_path_text_pattern_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_routes_on_path_text_pattern_ops ON public.routes USING btree (path varchar_pattern_ops);


--
-- Name: index_routes_on_source_type_and_source_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_routes_on_source_type_and_source_id ON public.routes USING btree (source_type, source_id);


--
-- Name: index_saml_providers_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_saml_providers_on_group_id ON public.saml_providers USING btree (group_id);


--
-- Name: index_scim_oauth_access_tokens_on_group_id_and_token_encrypted; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_scim_oauth_access_tokens_on_group_id_and_token_encrypted ON public.scim_oauth_access_tokens USING btree (group_id, token_encrypted);


--
-- Name: index_sent_notifications_on_reply_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sent_notifications_on_reply_key ON public.sent_notifications USING btree (reply_key);


--
-- Name: index_services_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_project_id ON public.services USING btree (project_id);


--
-- Name: index_services_on_template; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_template ON public.services USING btree (template);


--
-- Name: index_services_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_type ON public.services USING btree (type);


--
-- Name: index_shards_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_shards_on_name ON public.shards USING btree (name);


--
-- Name: index_slack_integrations_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_slack_integrations_on_service_id ON public.slack_integrations USING btree (service_id);


--
-- Name: index_slack_integrations_on_team_id_and_alias; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_slack_integrations_on_team_id_and_alias ON public.slack_integrations USING btree (team_id, alias);


--
-- Name: index_smartcard_identities_on_subject_and_issuer; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_smartcard_identities_on_subject_and_issuer ON public.smartcard_identities USING btree (subject, issuer);


--
-- Name: index_smartcard_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_smartcard_identities_on_user_id ON public.smartcard_identities USING btree (user_id);


--
-- Name: index_snippets_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snippets_on_author_id ON public.snippets USING btree (author_id);


--
-- Name: index_snippets_on_file_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snippets_on_file_name_trigram ON public.snippets USING gin (file_name public.gin_trgm_ops);


--
-- Name: index_snippets_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snippets_on_project_id ON public.snippets USING btree (project_id);


--
-- Name: index_snippets_on_title_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snippets_on_title_trigram ON public.snippets USING gin (title public.gin_trgm_ops);


--
-- Name: index_snippets_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snippets_on_updated_at ON public.snippets USING btree (updated_at);


--
-- Name: index_snippets_on_visibility_level; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snippets_on_visibility_level ON public.snippets USING btree (visibility_level);


--
-- Name: index_software_license_policies_on_software_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_software_license_policies_on_software_license_id ON public.software_license_policies USING btree (software_license_id);


--
-- Name: index_software_license_policies_unique_per_project; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_software_license_policies_unique_per_project ON public.software_license_policies USING btree (project_id, software_license_id);


--
-- Name: index_software_licenses_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_software_licenses_on_name ON public.software_licenses USING btree (name);


--
-- Name: index_subscriptions_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_project_id ON public.subscriptions USING btree (project_id);


--
-- Name: index_subscriptions_on_subscribable_and_user_id_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_subscribable_and_user_id_and_project_id ON public.subscriptions USING btree (subscribable_id, subscribable_type, user_id, project_id);


--
-- Name: index_suggestions_on_note_id_and_relative_order; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_suggestions_on_note_id_and_relative_order ON public.suggestions USING btree (note_id, relative_order);


--
-- Name: index_system_note_metadata_on_note_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_system_note_metadata_on_note_id ON public.system_note_metadata USING btree (note_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_tag_id ON public.taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type ON public.taggings USING btree (taggable_id, taggable_type);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON public.taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_tags_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_tags_on_name ON public.tags USING btree (name);


--
-- Name: index_tags_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tags_on_name_trigram ON public.tags USING gin (name public.gin_trgm_ops);


--
-- Name: index_term_agreements_on_term_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_term_agreements_on_term_id ON public.term_agreements USING btree (term_id);


--
-- Name: index_term_agreements_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_term_agreements_on_user_id ON public.term_agreements USING btree (user_id);


--
-- Name: index_timelogs_on_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timelogs_on_issue_id ON public.timelogs USING btree (issue_id);


--
-- Name: index_timelogs_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timelogs_on_merge_request_id ON public.timelogs USING btree (merge_request_id);


--
-- Name: index_timelogs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_timelogs_on_user_id ON public.timelogs USING btree (user_id);


--
-- Name: index_todos_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_author_id ON public.todos USING btree (author_id);


--
-- Name: index_todos_on_commit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_commit_id ON public.todos USING btree (commit_id);


--
-- Name: index_todos_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_group_id ON public.todos USING btree (group_id);


--
-- Name: index_todos_on_note_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_note_id ON public.todos USING btree (note_id);


--
-- Name: index_todos_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_project_id ON public.todos USING btree (project_id);


--
-- Name: index_todos_on_target_type_and_target_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_target_type_and_target_id ON public.todos USING btree (target_type, target_id);


--
-- Name: index_todos_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_user_id ON public.todos USING btree (user_id);


--
-- Name: index_todos_on_user_id_and_id_done; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_user_id_and_id_done ON public.todos USING btree (user_id, id) WHERE ((state)::text = 'done'::text);


--
-- Name: index_todos_on_user_id_and_id_pending; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_todos_on_user_id_and_id_pending ON public.todos USING btree (user_id, id) WHERE ((state)::text = 'pending'::text);


--
-- Name: index_trending_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_trending_projects_on_project_id ON public.trending_projects USING btree (project_id);


--
-- Name: index_u2f_registrations_on_key_handle; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_u2f_registrations_on_key_handle ON public.u2f_registrations USING btree (key_handle);


--
-- Name: index_u2f_registrations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_u2f_registrations_on_user_id ON public.u2f_registrations USING btree (user_id);


--
-- Name: index_uploads_on_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_checksum ON public.uploads USING btree (checksum);


--
-- Name: index_uploads_on_model_id_and_model_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_model_id_and_model_type ON public.uploads USING btree (model_id, model_type);


--
-- Name: index_uploads_on_store; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_store ON public.uploads USING btree (store);


--
-- Name: index_uploads_on_uploader_and_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_uploads_on_uploader_and_path ON public.uploads USING btree (uploader, path);


--
-- Name: index_user_agent_details_on_subject_id_and_subject_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_agent_details_on_subject_id_and_subject_type ON public.user_agent_details USING btree (subject_id, subject_type);


--
-- Name: index_user_callouts_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_callouts_on_user_id ON public.user_callouts USING btree (user_id);


--
-- Name: index_user_callouts_on_user_id_and_feature_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_callouts_on_user_id_and_feature_name ON public.user_callouts USING btree (user_id, feature_name);


--
-- Name: index_user_custom_attributes_on_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_custom_attributes_on_key_and_value ON public.user_custom_attributes USING btree (key, value);


--
-- Name: index_user_custom_attributes_on_user_id_and_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_custom_attributes_on_user_id_and_key ON public.user_custom_attributes USING btree (user_id, key);


--
-- Name: index_user_interacted_projects_on_project_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_interacted_projects_on_project_id_and_user_id ON public.user_interacted_projects USING btree (project_id, user_id);


--
-- Name: index_user_interacted_projects_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_interacted_projects_on_user_id ON public.user_interacted_projects USING btree (user_id);


--
-- Name: index_user_preferences_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_preferences_on_user_id ON public.user_preferences USING btree (user_id);


--
-- Name: index_user_statuses_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_statuses_on_user_id ON public.user_statuses USING btree (user_id);


--
-- Name: index_user_synced_attributes_metadata_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_synced_attributes_metadata_on_user_id ON public.user_synced_attributes_metadata USING btree (user_id);


--
-- Name: index_users_on_accepted_term_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_accepted_term_id ON public.users USING btree (accepted_term_id);


--
-- Name: index_users_on_admin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_admin ON public.users USING btree (admin);


--
-- Name: index_users_on_bot_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_bot_type ON public.users USING btree (bot_type);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_created_at ON public.users USING btree (created_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_email_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email_trigram ON public.users USING gin (email public.gin_trgm_ops);


--
-- Name: index_users_on_feed_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_feed_token ON public.users USING btree (feed_token);


--
-- Name: index_users_on_ghost; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_ghost ON public.users USING btree (ghost);


--
-- Name: index_users_on_group_view; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_group_view ON public.users USING btree (group_view);


--
-- Name: index_users_on_incoming_email_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_incoming_email_token ON public.users USING btree (incoming_email_token);


--
-- Name: index_users_on_managing_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_managing_group_id ON public.users USING btree (managing_group_id);


--
-- Name: index_users_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_name ON public.users USING btree (name);


--
-- Name: index_users_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_name_trigram ON public.users USING gin (name public.gin_trgm_ops);


--
-- Name: index_users_on_public_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_public_email ON public.users USING btree (public_email) WHERE ((public_email)::text <> ''::text);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_state ON public.users USING btree (state);


--
-- Name: index_users_on_state_and_internal; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_state_and_internal ON public.users USING btree (state) WHERE ((ghost <> true) AND (bot_type IS NULL));


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: index_users_on_username_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_username_trigram ON public.users USING gin (username public.gin_trgm_ops);


--
-- Name: index_users_ops_dashboard_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_ops_dashboard_projects_on_project_id ON public.users_ops_dashboard_projects USING btree (project_id);


--
-- Name: index_users_ops_dashboard_projects_on_user_id_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_ops_dashboard_projects_on_user_id_and_project_id ON public.users_ops_dashboard_projects USING btree (user_id, project_id);


--
-- Name: index_users_star_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_star_projects_on_project_id ON public.users_star_projects USING btree (project_id);


--
-- Name: index_users_star_projects_on_user_id_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_star_projects_on_user_id_and_project_id ON public.users_star_projects USING btree (user_id, project_id);


--
-- Name: index_vulnerability_feedback_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_feedback_on_author_id ON public.vulnerability_feedback USING btree (author_id);


--
-- Name: index_vulnerability_feedback_on_comment_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_feedback_on_comment_author_id ON public.vulnerability_feedback USING btree (comment_author_id);


--
-- Name: index_vulnerability_feedback_on_issue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_feedback_on_issue_id ON public.vulnerability_feedback USING btree (issue_id);


--
-- Name: index_vulnerability_feedback_on_merge_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_feedback_on_merge_request_id ON public.vulnerability_feedback USING btree (merge_request_id);


--
-- Name: index_vulnerability_feedback_on_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_feedback_on_pipeline_id ON public.vulnerability_feedback USING btree (pipeline_id);


--
-- Name: index_vulnerability_identifiers_on_project_id_and_fingerprint; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vulnerability_identifiers_on_project_id_and_fingerprint ON public.vulnerability_identifiers USING btree (project_id, fingerprint);


--
-- Name: index_vulnerability_occurrence_identifiers_on_identifier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_occurrence_identifiers_on_identifier_id ON public.vulnerability_occurrence_identifiers USING btree (identifier_id);


--
-- Name: index_vulnerability_occurrence_identifiers_on_unique_keys; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vulnerability_occurrence_identifiers_on_unique_keys ON public.vulnerability_occurrence_identifiers USING btree (occurrence_id, identifier_id);


--
-- Name: index_vulnerability_occurrence_pipelines_on_pipeline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_occurrence_pipelines_on_pipeline_id ON public.vulnerability_occurrence_pipelines USING btree (pipeline_id);


--
-- Name: index_vulnerability_occurrences_on_primary_identifier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_occurrences_on_primary_identifier_id ON public.vulnerability_occurrences USING btree (primary_identifier_id);


--
-- Name: index_vulnerability_occurrences_on_scanner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_vulnerability_occurrences_on_scanner_id ON public.vulnerability_occurrences USING btree (scanner_id);


--
-- Name: index_vulnerability_occurrences_on_unique_keys; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vulnerability_occurrences_on_unique_keys ON public.vulnerability_occurrences USING btree (project_id, primary_identifier_id, location_fingerprint, scanner_id);


--
-- Name: index_vulnerability_occurrences_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vulnerability_occurrences_on_uuid ON public.vulnerability_occurrences USING btree (uuid);


--
-- Name: index_vulnerability_scanners_on_project_id_and_external_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_vulnerability_scanners_on_project_id_and_external_id ON public.vulnerability_scanners USING btree (project_id, external_id);


--
-- Name: index_web_hook_logs_on_created_at_and_web_hook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_hook_logs_on_created_at_and_web_hook_id ON public.web_hook_logs USING btree (created_at, web_hook_id);


--
-- Name: index_web_hook_logs_on_web_hook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_hook_logs_on_web_hook_id ON public.web_hook_logs USING btree (web_hook_id);


--
-- Name: index_web_hooks_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_hooks_on_project_id ON public.web_hooks USING btree (project_id);


--
-- Name: index_web_hooks_on_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_web_hooks_on_type ON public.web_hooks USING btree (type);


--
-- Name: kubernetes_namespaces_cluster_and_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX kubernetes_namespaces_cluster_and_namespace ON public.clusters_kubernetes_namespaces USING btree (cluster_id, namespace);


--
-- Name: partial_index_ci_builds_on_scheduled_at_with_scheduled_jobs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX partial_index_ci_builds_on_scheduled_at_with_scheduled_jobs ON public.ci_builds USING btree (scheduled_at) WHERE ((scheduled_at IS NOT NULL) AND ((type)::text = 'Ci::Build'::text) AND ((status)::text = 'scheduled'::text));


--
-- Name: partial_index_deployments_for_legacy_successful_deployments; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX partial_index_deployments_for_legacy_successful_deployments ON public.deployments USING btree (id) WHERE ((finished_at IS NULL) AND (status = 2));


--
-- Name: projects_requiring_code_owner_approval; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX projects_requiring_code_owner_approval ON public.projects USING btree (archived, pending_delete, merge_requests_require_code_owner_approval) WHERE ((pending_delete = false) AND (archived = false) AND (merge_requests_require_code_owner_approval = true));


--
-- Name: taggings_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX taggings_idx ON public.taggings USING btree (tag_id, taggable_id, taggable_type, context, tagger_id, tagger_type);


--
-- Name: term_agreements_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX term_agreements_unique_index ON public.term_agreements USING btree (user_id, term_id);


--
-- Name: tmp_build_stage_position_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tmp_build_stage_position_index ON public.ci_builds USING btree (stage_id, stage_idx) WHERE (stage_idx IS NOT NULL);


--
-- Name: vulnerability_feedback_unique_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX vulnerability_feedback_unique_idx ON public.vulnerability_feedback USING btree (project_id, category, feedback_type, project_fingerprint);


--
-- Name: vulnerability_occurrence_pipelines_on_unique_keys; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX vulnerability_occurrence_pipelines_on_unique_keys ON public.vulnerability_occurrence_pipelines USING btree (occurrence_id, pipeline_id);


--
-- Name: clusters_applications_runners fk_02de2ded36; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_runners
    ADD CONSTRAINT fk_02de2ded36 FOREIGN KEY (runner_id) REFERENCES public.ci_runners(id) ON DELETE SET NULL;


--
-- Name: design_management_designs_versions fk_03c671965c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.design_management_designs_versions
    ADD CONSTRAINT fk_03c671965c FOREIGN KEY (design_id) REFERENCES public.design_management_designs(id) ON DELETE CASCADE;


--
-- Name: issues fk_05f1e72feb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT fk_05f1e72feb FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: merge_requests fk_06067f5644; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_06067f5644 FOREIGN KEY (latest_merge_request_diff_id) REFERENCES public.merge_request_diffs(id) ON DELETE SET NULL;


--
-- Name: user_interacted_projects fk_0894651f08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_interacted_projects
    ADD CONSTRAINT fk_0894651f08 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: web_hooks fk_0c8ca6d9d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_hooks
    ADD CONSTRAINT fk_0c8ca6d9d1 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: notification_settings fk_0c95e91db7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notification_settings
    ADD CONSTRAINT fk_0c95e91db7 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: lists fk_0d3f677137; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT fk_0d3f677137 FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: internal_ids fk_162941d509; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internal_ids
    ADD CONSTRAINT fk_162941d509 FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_176d3fbb5d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_176d3fbb5d FOREIGN KEY (job_artifact_deleted_event_id) REFERENCES public.geo_job_artifact_deleted_events(id) ON DELETE CASCADE;


--
-- Name: project_features fk_18513d9b92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_features
    ADD CONSTRAINT fk_18513d9b92 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_sources_pipelines fk_1e53c97c0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_sources_pipelines
    ADD CONSTRAINT fk_1e53c97c0a FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: users_star_projects fk_22cd27ddfc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_star_projects
    ADD CONSTRAINT fk_22cd27ddfc FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_stages fk_2360681d1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_stages
    ADD CONSTRAINT fk_2360681d1d FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_ci_cd_settings fk_24c15d2f2e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_ci_cd_settings
    ADD CONSTRAINT fk_24c15d2f2e FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: epics fk_25b99c1be3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT fk_25b99c1be3 FOREIGN KEY (parent_id) REFERENCES public.epics(id) ON DELETE CASCADE;


--
-- Name: ci_pipelines fk_262d4c2d19; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipelines
    ADD CONSTRAINT fk_262d4c2d19 FOREIGN KEY (auto_canceled_by_id) REFERENCES public.ci_pipelines(id) ON DELETE SET NULL;


--
-- Name: ci_build_trace_sections fk_264e112c66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_sections
    ADD CONSTRAINT fk_264e112c66 FOREIGN KEY (section_name_id) REFERENCES public.ci_build_trace_section_names(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_27548c6db3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_27548c6db3 FOREIGN KEY (hashed_storage_migrated_event_id) REFERENCES public.geo_hashed_storage_migrated_events(id) ON DELETE CASCADE;


--
-- Name: deployments fk_289bba3222; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deployments
    ADD CONSTRAINT fk_289bba3222 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE SET NULL;


--
-- Name: notes fk_2e82291620; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_2e82291620 FOREIGN KEY (review_id) REFERENCES public.reviews(id) ON DELETE SET NULL;


--
-- Name: members fk_2e88fb7ce9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT fk_2e88fb7ce9 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: approvals fk_310d714958; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approvals
    ADD CONSTRAINT fk_310d714958 FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: namespaces fk_319256d87a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces
    ADD CONSTRAINT fk_319256d87a FOREIGN KEY (file_template_project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: merge_requests fk_3308fe130c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_3308fe130c FOREIGN KEY (source_project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: ci_group_variables fk_33ae4d58d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_group_variables
    ADD CONSTRAINT fk_33ae4d58d8 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: epics fk_3654b61b03; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT fk_3654b61b03 FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: push_event_payloads fk_36c74129da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_event_payloads
    ADD CONSTRAINT fk_36c74129da FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: ci_builds fk_3a9eaa254d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds
    ADD CONSTRAINT fk_3a9eaa254d FOREIGN KEY (stage_id) REFERENCES public.ci_stages(id) ON DELETE CASCADE;


--
-- Name: ci_pipelines fk_3d34ab2e06; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipelines
    ADD CONSTRAINT fk_3d34ab2e06 FOREIGN KEY (pipeline_schedule_id) REFERENCES public.ci_pipeline_schedules(id) ON DELETE SET NULL;


--
-- Name: ci_pipeline_schedule_variables fk_41c35fda51; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_schedule_variables
    ADD CONSTRAINT fk_41c35fda51 FOREIGN KEY (pipeline_schedule_id) REFERENCES public.ci_pipeline_schedules(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_42c3b54bed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_42c3b54bed FOREIGN KEY (cache_invalidation_event_id) REFERENCES public.geo_cache_invalidation_events(id) ON DELETE CASCADE;


--
-- Name: forked_project_links fk_434510edb0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.forked_project_links
    ADD CONSTRAINT fk_434510edb0 FOREIGN KEY (forked_to_project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_runner_projects fk_4478a6f1e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runner_projects
    ADD CONSTRAINT fk_4478a6f1e4 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: todos fk_45054f9c45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT fk_45054f9c45 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: releases fk_47fe2a0596; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.releases
    ADD CONSTRAINT fk_47fe2a0596 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_4a99ebfd60; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_4a99ebfd60 FOREIGN KEY (repositories_changed_event_id) REFERENCES public.geo_repositories_changed_events(id) ON DELETE CASCADE;


--
-- Name: ci_build_trace_sections fk_4ebe41f502; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_sections
    ADD CONSTRAINT fk_4ebe41f502 FOREIGN KEY (build_id) REFERENCES public.ci_builds(id) ON DELETE CASCADE;


--
-- Name: path_locks fk_5265c98f24; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.path_locks
    ADD CONSTRAINT fk_5265c98f24 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: clusters_applications_prometheus fk_557e773639; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_prometheus
    ADD CONSTRAINT fk_557e773639 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: vulnerability_feedback fk_563ff1912e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_feedback
    ADD CONSTRAINT fk_563ff1912e FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE SET NULL;


--
-- Name: deploy_keys_projects fk_58a901ca7e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploy_keys_projects
    ADD CONSTRAINT fk_58a901ca7e FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: issue_assignees fk_5e0c8d9154; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_assignees
    ADD CONSTRAINT fk_5e0c8d9154 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: merge_requests fk_6149611a04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_6149611a04 FOREIGN KEY (assignee_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: dependency_proxy_group_settings fk_616ddd680a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dependency_proxy_group_settings
    ADD CONSTRAINT fk_616ddd680a FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: merge_requests fk_641731faff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_641731faff FOREIGN KEY (updated_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: merge_requests fk_6a5165a692; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_6a5165a692 FOREIGN KEY (milestone_id) REFERENCES public.milestones(id) ON DELETE SET NULL;


--
-- Name: projects fk_6e5c14658a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_6e5c14658a FOREIGN KEY (pool_repository_id) REFERENCES public.pool_repositories(id) ON DELETE SET NULL;


--
-- Name: protected_branch_push_access_levels fk_7111b68cdb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_push_access_levels
    ADD CONSTRAINT fk_7111b68cdb FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: services fk_71cce407f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT fk_71cce407f9 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: user_interacted_projects fk_722ceba4f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_interacted_projects
    ADD CONSTRAINT fk_722ceba4f7 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: index_statuses fk_74b2492545; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.index_statuses
    ADD CONSTRAINT fk_74b2492545 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: clusters_applications_ingress fk_753a7b41c1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_ingress
    ADD CONSTRAINT fk_753a7b41c1 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: users fk_789cd90b35; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_789cd90b35 FOREIGN KEY (accepted_term_id) REFERENCES public.application_setting_terms(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_78a6492f68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_78a6492f68 FOREIGN KEY (repository_updated_event_id) REFERENCES public.geo_repository_updated_events(id) ON DELETE CASCADE;


--
-- Name: lists fk_7a5553d60f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT fk_7a5553d60f FOREIGN KEY (label_id) REFERENCES public.labels(id) ON DELETE CASCADE;


--
-- Name: protected_branches fk_7a9c6d93e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branches
    ADD CONSTRAINT fk_7a9c6d93e7 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: labels fk_7de4989a69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labels
    ADD CONSTRAINT fk_7de4989a69 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_request_metrics fk_7f28d925f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_metrics
    ADD CONSTRAINT fk_7f28d925f3 FOREIGN KEY (merged_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: push_rules fk_83b29894de; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.push_rules
    ADD CONSTRAINT fk_83b29894de FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_request_diffs fk_8483f3258f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_diffs
    ADD CONSTRAINT fk_8483f3258f FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: ci_pipelines fk_86635dbd80; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipelines
    ADD CONSTRAINT fk_86635dbd80 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_86c84214ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_86c84214ec FOREIGN KEY (repository_renamed_event_id) REFERENCES public.geo_repository_renamed_events(id) ON DELETE CASCADE;


--
-- Name: packages_package_files fk_86f0f182f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_package_files
    ADD CONSTRAINT fk_86f0f182f8 FOREIGN KEY (package_id) REFERENCES public.packages_packages(id) ON DELETE CASCADE;


--
-- Name: ci_builds fk_87f4cefcda; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds
    ADD CONSTRAINT fk_87f4cefcda FOREIGN KEY (upstream_pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: issues fk_899c8f3231; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT fk_899c8f3231 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: protected_branch_merge_access_levels fk_8a3072ccb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_merge_access_levels
    ADD CONSTRAINT fk_8a3072ccb3 FOREIGN KEY (protected_branch_id) REFERENCES public.protected_branches(id) ON DELETE CASCADE;


--
-- Name: releases fk_8e4456f90f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.releases
    ADD CONSTRAINT fk_8e4456f90f FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: protected_tags fk_8e4af87648; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_tags
    ADD CONSTRAINT fk_8e4af87648 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_pipeline_schedules fk_8ead60fcc4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_schedules
    ADD CONSTRAINT fk_8ead60fcc4 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: todos fk_91d1f47b13; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT fk_91d1f47b13 FOREIGN KEY (note_id) REFERENCES public.notes(id) ON DELETE CASCADE;


--
-- Name: vulnerability_feedback fk_94f7c8a81e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_feedback
    ADD CONSTRAINT fk_94f7c8a81e FOREIGN KEY (comment_author_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: milestones fk_95650a40d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.milestones
    ADD CONSTRAINT fk_95650a40d4 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: application_settings fk_964370041d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings
    ADD CONSTRAINT fk_964370041d FOREIGN KEY (usage_stats_set_by_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: issues fk_96b1dd429c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT fk_96b1dd429c FOREIGN KEY (milestone_id) REFERENCES public.milestones(id) ON DELETE SET NULL;


--
-- Name: protected_branch_merge_access_levels fk_98f3d044fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_merge_access_levels
    ADD CONSTRAINT fk_98f3d044fe FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: notes fk_99e097b079; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT fk_99e097b079 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_9b9afb1916; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_9b9afb1916 FOREIGN KEY (repository_created_event_id) REFERENCES public.geo_repository_created_events(id) ON DELETE CASCADE;


--
-- Name: milestones fk_9bd0a0c791; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.milestones
    ADD CONSTRAINT fk_9bd0a0c791 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_pipeline_schedules fk_9ea99f58d2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_schedules
    ADD CONSTRAINT fk_9ea99f58d2 FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: protected_branch_push_access_levels fk_9ffc86a3d9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_push_access_levels
    ADD CONSTRAINT fk_9ffc86a3d9 FOREIGN KEY (protected_branch_id) REFERENCES public.protected_branches(id) ON DELETE CASCADE;


--
-- Name: issues fk_a194299be1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT fk_a194299be1 FOREIGN KEY (moved_to_id) REFERENCES public.issues(id) ON DELETE SET NULL;


--
-- Name: ci_builds fk_a2141b1522; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds
    ADD CONSTRAINT fk_a2141b1522 FOREIGN KEY (auto_canceled_by_id) REFERENCES public.ci_pipelines(id) ON DELETE SET NULL;


--
-- Name: ci_pipelines fk_a23be95014; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipelines
    ADD CONSTRAINT fk_a23be95014 FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: jira_connect_subscriptions fk_a3c10bcf7d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_connect_subscriptions
    ADD CONSTRAINT fk_a3c10bcf7d FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: users fk_a4b8fefe3e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_a4b8fefe3e FOREIGN KEY (managing_group_id) REFERENCES public.namespaces(id) ON DELETE SET NULL;


--
-- Name: merge_requests fk_a6963e8447; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_a6963e8447 FOREIGN KEY (target_project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: epics fk_aa5798e761; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT fk_aa5798e761 FOREIGN KEY (closed_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: identities fk_aade90f0fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT fk_aade90f0fc FOREIGN KEY (saml_provider_id) REFERENCES public.saml_providers(id) ON DELETE CASCADE;


--
-- Name: ci_sources_pipelines fk_acd9737679; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_sources_pipelines
    ADD CONSTRAINT fk_acd9737679 FOREIGN KEY (source_project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_requests fk_ad525e1f87; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_ad525e1f87 FOREIGN KEY (merge_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: ci_variables fk_ada5eb64b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_variables
    ADD CONSTRAINT fk_ada5eb64b3 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_request_metrics fk_ae440388cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_metrics
    ADD CONSTRAINT fk_ae440388cc FOREIGN KEY (latest_closed_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: fork_network_members fk_b01280dae4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fork_network_members
    ADD CONSTRAINT fk_b01280dae4 FOREIGN KEY (forked_from_project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: protected_tag_create_access_levels fk_b4eb82fe3c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_tag_create_access_levels
    ADD CONSTRAINT fk_b4eb82fe3c FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: issue_assignees fk_b7d881734a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_assignees
    ADD CONSTRAINT fk_b7d881734a FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: ci_trigger_requests fk_b8ec8b7245; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_trigger_requests
    ADD CONSTRAINT fk_b8ec8b7245 FOREIGN KEY (trigger_id) REFERENCES public.ci_triggers(id) ON DELETE CASCADE;


--
-- Name: deployments fk_b9a3851b82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deployments
    ADD CONSTRAINT fk_b9a3851b82 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: gitlab_subscriptions fk_bd0c4019c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gitlab_subscriptions
    ADD CONSTRAINT fk_bd0c4019c3 FOREIGN KEY (hosted_plan_id) REFERENCES public.plans(id) ON DELETE CASCADE;


--
-- Name: snippets fk_be41fd4bb7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.snippets
    ADD CONSTRAINT fk_be41fd4bb7 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_sources_pipelines fk_be5624bf37; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_sources_pipelines
    ADD CONSTRAINT fk_be5624bf37 FOREIGN KEY (source_job_id) REFERENCES public.ci_builds(id) ON DELETE CASCADE;


--
-- Name: packages_maven_metadata fk_be88aed360; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_maven_metadata
    ADD CONSTRAINT fk_be88aed360 FOREIGN KEY (package_id) REFERENCES public.packages_packages(id) ON DELETE CASCADE;


--
-- Name: ci_builds fk_befce0568a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds
    ADD CONSTRAINT fk_befce0568a FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_c1f241c70d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_c1f241c70d FOREIGN KEY (upload_deleted_event_id) REFERENCES public.geo_upload_deleted_events(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_c4b1c1f66e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_c4b1c1f66e FOREIGN KEY (repository_deleted_event_id) REFERENCES public.geo_repository_deleted_events(id) ON DELETE CASCADE;


--
-- Name: issues fk_c63cbf6c25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT fk_c63cbf6c25 FOREIGN KEY (closed_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: issue_links fk_c900194ff2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_links
    ADD CONSTRAINT fk_c900194ff2 FOREIGN KEY (source_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: todos fk_ccf0373936; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT fk_ccf0373936 FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_cff7185ad2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_cff7185ad2 FOREIGN KEY (reset_checksum_event_id) REFERENCES public.geo_reset_checksum_events(id) ON DELETE CASCADE;


--
-- Name: environments fk_d1c8c1da6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.environments
    ADD CONSTRAINT fk_d1c8c1da6a FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_builds fk_d3130c9a7f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds
    ADD CONSTRAINT fk_d3130c9a7f FOREIGN KEY (commit_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: ci_sources_pipelines fk_d4e29af7d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_sources_pipelines
    ADD CONSTRAINT fk_d4e29af7d7 FOREIGN KEY (source_pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: geo_event_log fk_d5af95fcd9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_event_log
    ADD CONSTRAINT fk_d5af95fcd9 FOREIGN KEY (lfs_object_deleted_event_id) REFERENCES public.geo_lfs_object_deleted_events(id) ON DELETE CASCADE;


--
-- Name: lists fk_d6cf4279f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT fk_d6cf4279f7 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: system_note_metadata fk_d83a918cb1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_note_metadata
    ADD CONSTRAINT fk_d83a918cb1 FOREIGN KEY (note_id) REFERENCES public.notes(id) ON DELETE CASCADE;


--
-- Name: todos fk_d94154aa95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT fk_d94154aa95 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: label_links fk_d97dd08678; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_links
    ADD CONSTRAINT fk_d97dd08678 FOREIGN KEY (label_id) REFERENCES public.labels(id) ON DELETE CASCADE;


--
-- Name: project_group_links fk_daa8cee94c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_group_links
    ADD CONSTRAINT fk_daa8cee94c FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: dependency_proxy_blobs fk_db58bbc5d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dependency_proxy_blobs
    ADD CONSTRAINT fk_db58bbc5d7 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: epics fk_dccd3f98fc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT fk_dccd3f98fc FOREIGN KEY (assignee_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: ci_sources_pipelines fk_e1bad85861; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_sources_pipelines
    ADD CONSTRAINT fk_e1bad85861 FOREIGN KEY (pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: gitlab_subscriptions fk_e2595d00a1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gitlab_subscriptions
    ADD CONSTRAINT fk_e2595d00a1 FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: ci_triggers fk_e3e63f966e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_triggers
    ADD CONSTRAINT fk_e3e63f966e FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_requests fk_e719a85f8a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_e719a85f8a FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: issue_links fk_e71bb44f1f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_links
    ADD CONSTRAINT fk_e71bb44f1f FOREIGN KEY (target_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: namespaces fk_e7a0b20a6b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces
    ADD CONSTRAINT fk_e7a0b20a6b FOREIGN KEY (custom_project_templates_group_id) REFERENCES public.namespaces(id) ON DELETE SET NULL;


--
-- Name: fork_networks fk_e7b436b2b5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fork_networks
    ADD CONSTRAINT fk_e7b436b2b5 FOREIGN KEY (root_project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: ci_triggers fk_e8e10d1964; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_triggers
    ADD CONSTRAINT fk_e8e10d1964 FOREIGN KEY (owner_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: pages_domains fk_ea2f6dfc6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages_domains
    ADD CONSTRAINT fk_ea2f6dfc6f FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: application_settings fk_ec757bd087; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings
    ADD CONSTRAINT fk_ec757bd087 FOREIGN KEY (file_template_project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: events fk_edfd187b6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_edfd187b6f FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: epics fk_f081aa4489; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT fk_f081aa4489 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: boards fk_f15266b5f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT fk_f15266b5f9 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: jira_connect_subscriptions fk_f1d617343f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_connect_subscriptions
    ADD CONSTRAINT fk_f1d617343f FOREIGN KEY (jira_connect_installation_id) REFERENCES public.jira_connect_installations(id) ON DELETE CASCADE;


--
-- Name: ci_pipeline_variables fk_f29c5f4380; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_variables
    ADD CONSTRAINT fk_f29c5f4380 FOREIGN KEY (pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: design_management_designs_versions fk_f4d25ba00c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.design_management_designs_versions
    ADD CONSTRAINT fk_f4d25ba00c FOREIGN KEY (version_id) REFERENCES public.design_management_versions(id) ON DELETE CASCADE;


--
-- Name: protected_tag_create_access_levels fk_f7dfda8c51; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_tag_create_access_levels
    ADD CONSTRAINT fk_f7dfda8c51 FOREIGN KEY (protected_tag_id) REFERENCES public.protected_tags(id) ON DELETE CASCADE;


--
-- Name: ci_stages fk_fb57e6cc56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_stages
    ADD CONSTRAINT fk_fb57e6cc56 FOREIGN KEY (pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: merge_requests fk_fd82eae0b9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests
    ADD CONSTRAINT fk_fd82eae0b9 FOREIGN KEY (head_pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE SET NULL;


--
-- Name: namespaces fk_fdd12e5b80; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces
    ADD CONSTRAINT fk_fdd12e5b80 FOREIGN KEY (plan_id) REFERENCES public.plans(id) ON DELETE SET NULL;


--
-- Name: project_import_data fk_ffb9ee3a10; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_import_data
    ADD CONSTRAINT fk_ffb9ee3a10 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: issues fk_ffed080f01; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT fk_ffed080f01 FOREIGN KEY (updated_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: oauth_openid_requests fk_oauth_openid_requests_oauth_access_grants_access_grant_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oauth_openid_requests
    ADD CONSTRAINT fk_oauth_openid_requests_oauth_access_grants_access_grant_id FOREIGN KEY (access_grant_id) REFERENCES public.oauth_access_grants(id);


--
-- Name: approval_merge_request_rules fk_rails_004ce82224; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules
    ADD CONSTRAINT fk_rails_004ce82224 FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: namespace_statistics fk_rails_0062050394; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_statistics
    ADD CONSTRAINT fk_rails_0062050394 FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: events fk_rails_0434b48643; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_0434b48643 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ip_restrictions fk_rails_04a93778d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ip_restrictions
    ADD CONSTRAINT fk_rails_04a93778d5 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: personal_access_tokens fk_rails_08903b8f38; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT fk_rails_08903b8f38 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: trending_projects fk_rails_09feecd872; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trending_projects
    ADD CONSTRAINT fk_rails_09feecd872 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_deploy_tokens fk_rails_0aca134388; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_deploy_tokens
    ADD CONSTRAINT fk_rails_0aca134388 FOREIGN KEY (deploy_token_id) REFERENCES public.deploy_tokens(id) ON DELETE CASCADE;


--
-- Name: geo_node_statuses fk_rails_0ecc699c2a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_node_statuses
    ADD CONSTRAINT fk_rails_0ecc699c2a FOREIGN KEY (geo_node_id) REFERENCES public.geo_nodes(id) ON DELETE CASCADE;


--
-- Name: project_repository_states fk_rails_0f2298ca8a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_repository_states
    ADD CONSTRAINT fk_rails_0f2298ca8a FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: user_synced_attributes_metadata fk_rails_0f4aa0981f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_synced_attributes_metadata
    ADD CONSTRAINT fk_rails_0f4aa0981f FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: project_authorizations fk_rails_0f84bb11f3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_authorizations
    ADD CONSTRAINT fk_rails_0f84bb11f3 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_build_trace_chunks fk_rails_1013b761f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_chunks
    ADD CONSTRAINT fk_rails_1013b761f2 FOREIGN KEY (build_id) REFERENCES public.ci_builds(id) ON DELETE CASCADE;


--
-- Name: prometheus_alert_events fk_rails_106f901176; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alert_events
    ADD CONSTRAINT fk_rails_106f901176 FOREIGN KEY (prometheus_alert_id) REFERENCES public.prometheus_alerts(id) ON DELETE CASCADE;


--
-- Name: gpg_signatures fk_rails_11ae8cb9a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_signatures
    ADD CONSTRAINT fk_rails_11ae8cb9a7 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_authorizations fk_rails_11e7aa3ed9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_authorizations
    ADD CONSTRAINT fk_rails_11e7aa3ed9 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: project_statistics fk_rails_12c471002f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_statistics
    ADD CONSTRAINT fk_rails_12c471002f FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_deploy_tokens fk_rails_170e03cbaf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_deploy_tokens
    ADD CONSTRAINT fk_rails_170e03cbaf FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: clusters_applications_jupyter fk_rails_17df21c98c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_jupyter
    ADD CONSTRAINT fk_rails_17df21c98c FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: gpg_signatures fk_rails_19d4f1c6f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_signatures
    ADD CONSTRAINT fk_rails_19d4f1c6f9 FOREIGN KEY (gpg_key_subkey_id) REFERENCES public.gpg_key_subkeys(id) ON DELETE SET NULL;


--
-- Name: epics fk_rails_1bf671ebb7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epics
    ADD CONSTRAINT fk_rails_1bf671ebb7 FOREIGN KEY (milestone_id) REFERENCES public.milestones(id) ON DELETE SET NULL;


--
-- Name: board_assignees fk_rails_1c0ff59e82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_assignees
    ADD CONSTRAINT fk_rails_1c0ff59e82 FOREIGN KEY (assignee_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: approver_groups fk_rails_1cdcbd7723; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approver_groups
    ADD CONSTRAINT fk_rails_1cdcbd7723 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: boards fk_rails_1e9a074a35; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.boards
    ADD CONSTRAINT fk_rails_1e9a074a35 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: geo_repository_created_events fk_rails_1f49e46a61; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_created_events
    ADD CONSTRAINT fk_rails_1f49e46a61 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: approval_merge_request_rules_groups fk_rails_2020a7124a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_groups
    ADD CONSTRAINT fk_rails_2020a7124a FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: vulnerability_feedback fk_rails_20976e6fd9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_feedback
    ADD CONSTRAINT fk_rails_20976e6fd9 FOREIGN KEY (pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE SET NULL;


--
-- Name: user_statuses fk_rails_2178592333; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_statuses
    ADD CONSTRAINT fk_rails_2178592333 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users_ops_dashboard_projects fk_rails_220a0562db; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_ops_dashboard_projects
    ADD CONSTRAINT fk_rails_220a0562db FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: clusters_applications_runners fk_rails_22388594e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_runners
    ADD CONSTRAINT fk_rails_22388594e9 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: protected_tag_create_access_levels fk_rails_2349b78b91; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_tag_create_access_levels
    ADD CONSTRAINT fk_rails_2349b78b91 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: group_custom_attributes fk_rails_246e0db83a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_custom_attributes
    ADD CONSTRAINT fk_rails_246e0db83a FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: lfs_file_locks fk_rails_27a1d98fa8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lfs_file_locks
    ADD CONSTRAINT fk_rails_27a1d98fa8 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: project_alerting_settings fk_rails_27a84b407d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_alerting_settings
    ADD CONSTRAINT fk_rails_27a84b407d FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: reviews fk_rails_29e6f859c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_29e6f859c4 FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: draft_notes fk_rails_2a8dac9901; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_notes
    ADD CONSTRAINT fk_rails_2a8dac9901 FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: geo_repository_updated_events fk_rails_2b70854c08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_updated_events
    ADD CONSTRAINT fk_rails_2b70854c08 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: protected_branch_unprotect_access_levels fk_rails_2d2aba21ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_unprotect_access_levels
    ADD CONSTRAINT fk_rails_2d2aba21ef FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: saml_providers fk_rails_306d459be7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.saml_providers
    ADD CONSTRAINT fk_rails_306d459be7 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: merge_request_diff_commits fk_rails_316aaceda3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_diff_commits
    ADD CONSTRAINT fk_rails_316aaceda3 FOREIGN KEY (merge_request_diff_id) REFERENCES public.merge_request_diffs(id) ON DELETE CASCADE;


--
-- Name: container_repositories fk_rails_32f7bf5aad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.container_repositories
    ADD CONSTRAINT fk_rails_32f7bf5aad FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: clusters_applications_jupyter fk_rails_331f0aff78; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_jupyter
    ADD CONSTRAINT fk_rails_331f0aff78 FOREIGN KEY (oauth_application_id) REFERENCES public.oauth_applications(id) ON DELETE SET NULL;


--
-- Name: merge_request_metrics fk_rails_33ae169d48; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_metrics
    ADD CONSTRAINT fk_rails_33ae169d48 FOREIGN KEY (pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: suggestions fk_rails_33b03a535c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT fk_rails_33b03a535c FOREIGN KEY (note_id) REFERENCES public.notes(id) ON DELETE CASCADE;


--
-- Name: board_labels fk_rails_362b0600a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_labels
    ADD CONSTRAINT fk_rails_362b0600a3 FOREIGN KEY (label_id) REFERENCES public.labels(id) ON DELETE CASCADE;


--
-- Name: merge_request_blocks fk_rails_364d4bea8b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_blocks
    ADD CONSTRAINT fk_rails_364d4bea8b FOREIGN KEY (blocked_merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: approval_project_rules_groups fk_rails_396841e79e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules_groups
    ADD CONSTRAINT fk_rails_396841e79e FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: chat_teams fk_rails_3b543909cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.chat_teams
    ADD CONSTRAINT fk_rails_3b543909cb FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: cluster_groups fk_rails_3d28377556; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_groups
    ADD CONSTRAINT fk_rails_3d28377556 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: note_diff_files fk_rails_3d66047aeb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.note_diff_files
    ADD CONSTRAINT fk_rails_3d66047aeb FOREIGN KEY (diff_note_id) REFERENCES public.notes(id) ON DELETE CASCADE;


--
-- Name: clusters_applications_helm fk_rails_3e2b1c06bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_helm
    ADD CONSTRAINT fk_rails_3e2b1c06bc FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: board_assignees fk_rails_3f6f926bd5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_assignees
    ADD CONSTRAINT fk_rails_3f6f926bd5 FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: clusters_kubernetes_namespaces fk_rails_40cc7ccbc3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_kubernetes_namespaces
    ADD CONSTRAINT fk_rails_40cc7ccbc3 FOREIGN KEY (cluster_project_id) REFERENCES public.cluster_projects(id) ON DELETE SET NULL;


--
-- Name: geo_node_namespace_links fk_rails_41ff5fb854; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_node_namespace_links
    ADD CONSTRAINT fk_rails_41ff5fb854 FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: epic_issues fk_rails_4209981af6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epic_issues
    ADD CONSTRAINT fk_rails_4209981af6 FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: remote_mirrors fk_rails_43a9aa4ca8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.remote_mirrors
    ADD CONSTRAINT fk_rails_43a9aa4ca8 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: lfs_file_locks fk_rails_43df7a0412; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lfs_file_locks
    ADD CONSTRAINT fk_rails_43df7a0412 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_request_assignees fk_rails_443443ce6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_assignees
    ADD CONSTRAINT fk_rails_443443ce6f FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: project_auto_devops fk_rails_45436b12b2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_auto_devops
    ADD CONSTRAINT fk_rails_45436b12b2 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_requests_closing_issues fk_rails_458eda8667; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests_closing_issues
    ADD CONSTRAINT fk_rails_458eda8667 FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: protected_environment_deploy_access_levels fk_rails_45cc02a931; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_environment_deploy_access_levels
    ADD CONSTRAINT fk_rails_45cc02a931 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: prometheus_alert_events fk_rails_4675865839; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alert_events
    ADD CONSTRAINT fk_rails_4675865839 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: smartcard_identities fk_rails_4689f889a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.smartcard_identities
    ADD CONSTRAINT fk_rails_4689f889a9 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: vulnerability_feedback fk_rails_472f69b043; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_feedback
    ADD CONSTRAINT fk_rails_472f69b043 FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_custom_attributes fk_rails_47b91868a8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_custom_attributes
    ADD CONSTRAINT fk_rails_47b91868a8 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: design_management_designs fk_rails_4bb1073360; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.design_management_designs
    ADD CONSTRAINT fk_rails_4bb1073360 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: issue_metrics fk_rails_4bb543d85d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_metrics
    ADD CONSTRAINT fk_rails_4bb543d85d FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: project_metrics_settings fk_rails_4c6037ee4f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_metrics_settings
    ADD CONSTRAINT fk_rails_4c6037ee4f FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: prometheus_metrics fk_rails_4c8957a707; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_metrics
    ADD CONSTRAINT fk_rails_4c8957a707 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: geo_repository_renamed_events fk_rails_4e6524febb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repository_renamed_events
    ADD CONSTRAINT fk_rails_4e6524febb FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_request_diff_files fk_rails_501aa0a391; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_diff_files
    ADD CONSTRAINT fk_rails_501aa0a391 FOREIGN KEY (merge_request_diff_id) REFERENCES public.merge_request_diffs(id) ON DELETE CASCADE;


--
-- Name: geo_node_namespace_links fk_rails_546bf08d3e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_node_namespace_links
    ADD CONSTRAINT fk_rails_546bf08d3e FOREIGN KEY (geo_node_id) REFERENCES public.geo_nodes(id) ON DELETE CASCADE;


--
-- Name: clusters_applications_knative fk_rails_54fc91e0a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_knative
    ADD CONSTRAINT fk_rails_54fc91e0a0 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: merge_request_assignees fk_rails_579d375628; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_assignees
    ADD CONSTRAINT fk_rails_579d375628 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: badges fk_rails_5a7c055bdc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT fk_rails_5a7c055bdc FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: resource_label_events fk_rails_5ac1d2fc24; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_label_events
    ADD CONSTRAINT fk_rails_5ac1d2fc24 FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: approval_merge_request_rules_groups fk_rails_5b2ecf6139; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_groups
    ADD CONSTRAINT fk_rails_5b2ecf6139 FOREIGN KEY (approval_merge_request_rule_id) REFERENCES public.approval_merge_request_rules(id) ON DELETE CASCADE;


--
-- Name: protected_environment_deploy_access_levels fk_rails_5b9f6970fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_environment_deploy_access_levels
    ADD CONSTRAINT fk_rails_5b9f6970fe FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: protected_branch_unprotect_access_levels fk_rails_5be1abfc25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_unprotect_access_levels
    ADD CONSTRAINT fk_rails_5be1abfc25 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: cluster_providers_gcp fk_rails_5c2c3bc814; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_providers_gcp
    ADD CONSTRAINT fk_rails_5c2c3bc814 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: insights fk_rails_5c4391f60a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insights
    ADD CONSTRAINT fk_rails_5c4391f60a FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: vulnerability_scanners fk_rails_5c9d42a221; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_scanners
    ADD CONSTRAINT fk_rails_5c9d42a221 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: reviews fk_rails_5ca11d8c31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_5ca11d8c31 FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: epic_issues fk_rails_5d942936b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epic_issues
    ADD CONSTRAINT fk_rails_5d942936b4 FOREIGN KEY (epic_id) REFERENCES public.epics(id) ON DELETE CASCADE;


--
-- Name: approval_project_rules fk_rails_5fb4dd100b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules
    ADD CONSTRAINT fk_rails_5fb4dd100b FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: protected_branch_merge_access_levels fk_rails_5ffb4f3590; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_merge_access_levels
    ADD CONSTRAINT fk_rails_5ffb4f3590 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: vulnerability_occurrence_pipelines fk_rails_6421e35d7d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrence_pipelines
    ADD CONSTRAINT fk_rails_6421e35d7d FOREIGN KEY (pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: reviews fk_rails_64798be025; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_64798be025 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: operations_feature_flags fk_rails_648e241be7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flags
    ADD CONSTRAINT fk_rails_648e241be7 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: board_group_recent_visits fk_rails_64bfc19bc5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_group_recent_visits
    ADD CONSTRAINT fk_rails_64bfc19bc5 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: approval_merge_request_rule_sources fk_rails_64e8ed3c7e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rule_sources
    ADD CONSTRAINT fk_rails_64e8ed3c7e FOREIGN KEY (approval_project_rule_id) REFERENCES public.approval_project_rules(id) ON DELETE CASCADE;


--
-- Name: ci_pipeline_chat_data fk_rails_64ebfab6b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_chat_data
    ADD CONSTRAINT fk_rails_64ebfab6b3 FOREIGN KEY (pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE CASCADE;


--
-- Name: approval_merge_request_rules_approved_approvers fk_rails_6577725edb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_approved_approvers
    ADD CONSTRAINT fk_rails_6577725edb FOREIGN KEY (approval_merge_request_rule_id) REFERENCES public.approval_merge_request_rules(id) ON DELETE CASCADE;


--
-- Name: operations_feature_flags_clients fk_rails_6650ed902c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flags_clients
    ADD CONSTRAINT fk_rails_6650ed902c FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: web_hook_logs fk_rails_666826e111; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.web_hook_logs
    ADD CONSTRAINT fk_rails_666826e111 FOREIGN KEY (web_hook_id) REFERENCES public.web_hooks(id) ON DELETE CASCADE;


--
-- Name: geo_hashed_storage_migrated_events fk_rails_687ed7d7c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_hashed_storage_migrated_events
    ADD CONSTRAINT fk_rails_687ed7d7c5 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: prometheus_alerts fk_rails_6d9b283465; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alerts
    ADD CONSTRAINT fk_rails_6d9b283465 FOREIGN KEY (environment_id) REFERENCES public.environments(id) ON DELETE CASCADE;


--
-- Name: term_agreements fk_rails_6ea6520e4a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.term_agreements
    ADD CONSTRAINT fk_rails_6ea6520e4a FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: ci_builds_runner_session fk_rails_70707857d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds_runner_session
    ADD CONSTRAINT fk_rails_70707857d3 FOREIGN KEY (build_id) REFERENCES public.ci_builds(id) ON DELETE CASCADE;


--
-- Name: project_custom_attributes fk_rails_719c3dccc5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_custom_attributes
    ADD CONSTRAINT fk_rails_719c3dccc5 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: slack_integrations fk_rails_73db19721a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slack_integrations
    ADD CONSTRAINT fk_rails_73db19721a FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: release_links fk_rails_753be7ae29; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.release_links
    ADD CONSTRAINT fk_rails_753be7ae29 FOREIGN KEY (release_id) REFERENCES public.releases(id) ON DELETE CASCADE;


--
-- Name: geo_repositories_changed_events fk_rails_75ec0fefcc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_repositories_changed_events
    ADD CONSTRAINT fk_rails_75ec0fefcc FOREIGN KEY (geo_node_id) REFERENCES public.geo_nodes(id) ON DELETE CASCADE;


--
-- Name: resource_label_events fk_rails_75efb0a653; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_label_events
    ADD CONSTRAINT fk_rails_75efb0a653 FOREIGN KEY (epic_id) REFERENCES public.epics(id) ON DELETE CASCADE;


--
-- Name: path_locks fk_rails_762cdcf942; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.path_locks
    ADD CONSTRAINT fk_rails_762cdcf942 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: pages_domain_acme_orders fk_rails_76581b1c16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pages_domain_acme_orders
    ADD CONSTRAINT fk_rails_76581b1c16 FOREIGN KEY (pages_domain_id) REFERENCES public.pages_domains(id) ON DELETE CASCADE;


--
-- Name: software_license_policies fk_rails_7a7a2a92de; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_license_policies
    ADD CONSTRAINT fk_rails_7a7a2a92de FOREIGN KEY (software_license_id) REFERENCES public.software_licenses(id) ON DELETE CASCADE;


--
-- Name: project_repositories fk_rails_7a810d4121; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_repositories
    ADD CONSTRAINT fk_rails_7a810d4121 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: clusters_kubernetes_namespaces fk_rails_7e7688ecaf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_kubernetes_namespaces
    ADD CONSTRAINT fk_rails_7e7688ecaf FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: approval_merge_request_rules_users fk_rails_80e6801803; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_users
    ADD CONSTRAINT fk_rails_80e6801803 FOREIGN KEY (approval_merge_request_rule_id) REFERENCES public.approval_merge_request_rules(id) ON DELETE CASCADE;


--
-- Name: ci_runner_namespaces fk_rails_8767676b7a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runner_namespaces
    ADD CONSTRAINT fk_rails_8767676b7a FOREIGN KEY (runner_id) REFERENCES public.ci_runners(id) ON DELETE CASCADE;


--
-- Name: software_license_policies fk_rails_87b2247ce5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.software_license_policies
    ADD CONSTRAINT fk_rails_87b2247ce5 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: protected_environment_deploy_access_levels fk_rails_898a13b650; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_environment_deploy_access_levels
    ADD CONSTRAINT fk_rails_898a13b650 FOREIGN KEY (protected_environment_id) REFERENCES public.protected_environments(id) ON DELETE CASCADE;


--
-- Name: gpg_key_subkeys fk_rails_8b2c90b046; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_key_subkeys
    ADD CONSTRAINT fk_rails_8b2c90b046 FOREIGN KEY (gpg_key_id) REFERENCES public.gpg_keys(id) ON DELETE CASCADE;


--
-- Name: cluster_projects fk_rails_8b8c5caf07; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_projects
    ADD CONSTRAINT fk_rails_8b8c5caf07 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: vulnerability_feedback fk_rails_8c77e5891a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_feedback
    ADD CONSTRAINT fk_rails_8c77e5891a FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON DELETE SET NULL;


--
-- Name: approval_merge_request_rules_approved_approvers fk_rails_8dc94cff4d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_approved_approvers
    ADD CONSTRAINT fk_rails_8dc94cff4d FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: protected_branch_push_access_levels fk_rails_8dcb712d65; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_push_access_levels
    ADD CONSTRAINT fk_rails_8dcb712d65 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: project_daily_statistics fk_rails_8e549b272d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_daily_statistics
    ADD CONSTRAINT fk_rails_8e549b272d FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: approval_project_rules_groups fk_rails_9071e863d1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules_groups
    ADD CONSTRAINT fk_rails_9071e863d1 FOREIGN KEY (approval_project_rule_id) REFERENCES public.approval_project_rules(id) ON DELETE CASCADE;


--
-- Name: vulnerability_occurrences fk_rails_90fed4faba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrences
    ADD CONSTRAINT fk_rails_90fed4faba FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: geo_reset_checksum_events fk_rails_910a06f12b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_reset_checksum_events
    ADD CONSTRAINT fk_rails_910a06f12b FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_error_tracking_settings fk_rails_910a2b8bd9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_error_tracking_settings
    ADD CONSTRAINT fk_rails_910a2b8bd9 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: board_labels fk_rails_9374a16edd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_labels
    ADD CONSTRAINT fk_rails_9374a16edd FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: resource_label_events fk_rails_9851a00031; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_label_events
    ADD CONSTRAINT fk_rails_9851a00031 FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: ci_job_artifacts fk_rails_9862d392f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_job_artifacts
    ADD CONSTRAINT fk_rails_9862d392f9 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: board_project_recent_visits fk_rails_98f8843922; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_project_recent_visits
    ADD CONSTRAINT fk_rails_98f8843922 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: clusters_kubernetes_namespaces fk_rails_98fe21e486; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_kubernetes_namespaces
    ADD CONSTRAINT fk_rails_98fe21e486 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: users_ops_dashboard_projects fk_rails_9b4ebf005b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_ops_dashboard_projects
    ADD CONSTRAINT fk_rails_9b4ebf005b FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_incident_management_settings fk_rails_9c2ea1b7dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_incident_management_settings
    ADD CONSTRAINT fk_rails_9c2ea1b7dd FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: gpg_keys fk_rails_9d1f5d8719; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_keys
    ADD CONSTRAINT fk_rails_9d1f5d8719 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: badges fk_rails_9df4a56538; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT fk_rails_9df4a56538 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: clusters_applications_cert_managers fk_rails_9e4f2cb4b2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters_applications_cert_managers
    ADD CONSTRAINT fk_rails_9e4f2cb4b2 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: namespace_root_storage_statistics fk_rails_a0702c430b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_root_storage_statistics
    ADD CONSTRAINT fk_rails_a0702c430b FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: project_aliases fk_rails_a1804f74a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_aliases
    ADD CONSTRAINT fk_rails_a1804f74a7 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: todos fk_rails_a27c483435; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.todos
    ADD CONSTRAINT fk_rails_a27c483435 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: jira_tracker_data fk_rails_a299066916; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_tracker_data
    ADD CONSTRAINT fk_rails_a299066916 FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: protected_environments fk_rails_a354313d11; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_environments
    ADD CONSTRAINT fk_rails_a354313d11 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: fork_network_members fk_rails_a40860a1ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fork_network_members
    ADD CONSTRAINT fk_rails_a40860a1ca FOREIGN KEY (fork_network_id) REFERENCES public.fork_networks(id) ON DELETE CASCADE;


--
-- Name: operations_feature_flag_scopes fk_rails_a50a04d0a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operations_feature_flag_scopes
    ADD CONSTRAINT fk_rails_a50a04d0a4 FOREIGN KEY (feature_flag_id) REFERENCES public.operations_feature_flags(id) ON DELETE CASCADE;


--
-- Name: cluster_projects fk_rails_a5a958bca1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_projects
    ADD CONSTRAINT fk_rails_a5a958bca1 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: vulnerability_identifiers fk_rails_a67a16c885; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_identifiers
    ADD CONSTRAINT fk_rails_a67a16c885 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: user_preferences fk_rails_a69bfcfd81; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT fk_rails_a69bfcfd81 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: repository_languages fk_rails_a750ec87a8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repository_languages
    ADD CONSTRAINT fk_rails_a750ec87a8 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: term_agreements fk_rails_a88721bcdf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.term_agreements
    ADD CONSTRAINT fk_rails_a88721bcdf FOREIGN KEY (term_id) REFERENCES public.application_setting_terms(id);


--
-- Name: ci_build_trace_sections fk_rails_ab7c104e26; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_sections
    ADD CONSTRAINT fk_rails_ab7c104e26 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: clusters fk_rails_ac3a663d79; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusters
    ADD CONSTRAINT fk_rails_ac3a663d79 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: pool_repositories fk_rails_af3f8c5d62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_repositories
    ADD CONSTRAINT fk_rails_af3f8c5d62 FOREIGN KEY (shard_id) REFERENCES public.shards(id) ON DELETE RESTRICT;


--
-- Name: resource_label_events fk_rails_b126799f57; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_label_events
    ADD CONSTRAINT fk_rails_b126799f57 FOREIGN KEY (label_id) REFERENCES public.labels(id) ON DELETE SET NULL;


--
-- Name: merge_trains fk_rails_b29261ce31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_trains
    ADD CONSTRAINT fk_rails_b29261ce31 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: board_project_recent_visits fk_rails_b315dd0c80; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_project_recent_visits
    ADD CONSTRAINT fk_rails_b315dd0c80 FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: merge_trains fk_rails_b374b5225d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_trains
    ADD CONSTRAINT fk_rails_b374b5225d FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: application_settings fk_rails_b53e481273; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings
    ADD CONSTRAINT fk_rails_b53e481273 FOREIGN KEY (custom_project_templates_group_id) REFERENCES public.namespaces(id) ON DELETE SET NULL;


--
-- Name: namespace_aggregation_schedules fk_rails_b565c8d16c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_aggregation_schedules
    ADD CONSTRAINT fk_rails_b565c8d16c FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: merge_trains fk_rails_b9d67af01d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_trains
    ADD CONSTRAINT fk_rails_b9d67af01d FOREIGN KEY (target_project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: approval_project_rules_users fk_rails_b9e9394efb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules_users
    ADD CONSTRAINT fk_rails_b9e9394efb FOREIGN KEY (approval_project_rule_id) REFERENCES public.approval_project_rules(id) ON DELETE CASCADE;


--
-- Name: lists fk_rails_baed5f39b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT fk_rails_baed5f39b7 FOREIGN KEY (milestone_id) REFERENCES public.milestones(id) ON DELETE CASCADE;


--
-- Name: approval_merge_request_rules_users fk_rails_bc8972fa55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rules_users
    ADD CONSTRAINT fk_rails_bc8972fa55 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: elasticsearch_indexed_projects fk_rails_bd13bbdc3d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elasticsearch_indexed_projects
    ADD CONSTRAINT fk_rails_bd13bbdc3d FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: elasticsearch_indexed_namespaces fk_rails_bdcf044f37; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elasticsearch_indexed_namespaces
    ADD CONSTRAINT fk_rails_bdcf044f37 FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: vulnerability_occurrence_identifiers fk_rails_be2e49e1d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrence_identifiers
    ADD CONSTRAINT fk_rails_be2e49e1d0 FOREIGN KEY (identifier_id) REFERENCES public.vulnerability_identifiers(id) ON DELETE CASCADE;


--
-- Name: vulnerability_occurrences fk_rails_bf5b788ca7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrences
    ADD CONSTRAINT fk_rails_bf5b788ca7 FOREIGN KEY (scanner_id) REFERENCES public.vulnerability_scanners(id) ON DELETE CASCADE;


--
-- Name: design_management_designs fk_rails_bfe283ec3c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.design_management_designs
    ADD CONSTRAINT fk_rails_bfe283ec3c FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: u2f_registrations fk_rails_bfe6a84544; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.u2f_registrations
    ADD CONSTRAINT fk_rails_bfe6a84544 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: labels fk_rails_c1ac5161d8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labels
    ADD CONSTRAINT fk_rails_c1ac5161d8 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: project_feature_usages fk_rails_c22a50024b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_feature_usages
    ADD CONSTRAINT fk_rails_c22a50024b FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_repositories fk_rails_c3258dc63b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_repositories
    ADD CONSTRAINT fk_rails_c3258dc63b FOREIGN KEY (shard_id) REFERENCES public.shards(id) ON DELETE RESTRICT;


--
-- Name: ci_job_artifacts fk_rails_c5137cb2c1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_job_artifacts
    ADD CONSTRAINT fk_rails_c5137cb2c1 FOREIGN KEY (job_id) REFERENCES public.ci_builds(id) ON DELETE CASCADE;


--
-- Name: scim_oauth_access_tokens fk_rails_c84404fb6c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scim_oauth_access_tokens
    ADD CONSTRAINT fk_rails_c84404fb6c FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: vulnerability_occurrences fk_rails_c8661a61eb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrences
    ADD CONSTRAINT fk_rails_c8661a61eb FOREIGN KEY (primary_identifier_id) REFERENCES public.vulnerability_identifiers(id) ON DELETE CASCADE;


--
-- Name: gpg_signatures fk_rails_c97176f5f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpg_signatures
    ADD CONSTRAINT fk_rails_c97176f5f7 FOREIGN KEY (gpg_key_id) REFERENCES public.gpg_keys(id) ON DELETE SET NULL;


--
-- Name: board_group_recent_visits fk_rails_ca04c38720; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_group_recent_visits
    ADD CONSTRAINT fk_rails_ca04c38720 FOREIGN KEY (board_id) REFERENCES public.boards(id) ON DELETE CASCADE;


--
-- Name: issue_tracker_data fk_rails_ccc0840427; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.issue_tracker_data
    ADD CONSTRAINT fk_rails_ccc0840427 FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: epic_metrics fk_rails_d071904753; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.epic_metrics
    ADD CONSTRAINT fk_rails_d071904753 FOREIGN KEY (epic_id) REFERENCES public.epics(id) ON DELETE CASCADE;


--
-- Name: subscriptions fk_rails_d0c8bda804; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_d0c8bda804 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_mirror_data fk_rails_d1aad367d7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_mirror_data
    ADD CONSTRAINT fk_rails_d1aad367d7 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: pool_repositories fk_rails_d2711daad4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_repositories
    ADD CONSTRAINT fk_rails_d2711daad4 FOREIGN KEY (source_project_id) REFERENCES public.projects(id) ON DELETE SET NULL;


--
-- Name: geo_hashed_storage_attachments_events fk_rails_d496b088e9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_hashed_storage_attachments_events
    ADD CONSTRAINT fk_rails_d496b088e9 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: vulnerability_occurrence_pipelines fk_rails_dc3ae04693; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrence_pipelines
    ADD CONSTRAINT fk_rails_dc3ae04693 FOREIGN KEY (occurrence_id) REFERENCES public.vulnerability_occurrences(id) ON DELETE CASCADE;


--
-- Name: user_callouts fk_rails_ddfdd80f3d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_callouts
    ADD CONSTRAINT fk_rails_ddfdd80f3d FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: vulnerability_feedback fk_rails_debd54e456; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_feedback
    ADD CONSTRAINT fk_rails_debd54e456 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: label_priorities fk_rails_e161058b0f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_priorities
    ADD CONSTRAINT fk_rails_e161058b0f FOREIGN KEY (label_id) REFERENCES public.labels(id) ON DELETE CASCADE;


--
-- Name: packages_packages fk_rails_e1ac527425; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.packages_packages
    ADD CONSTRAINT fk_rails_e1ac527425 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: cluster_platforms_kubernetes fk_rails_e1e2cf841a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_platforms_kubernetes
    ADD CONSTRAINT fk_rails_e1e2cf841a FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: ci_builds_metadata fk_rails_e20479742e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds_metadata
    ADD CONSTRAINT fk_rails_e20479742e FOREIGN KEY (build_id) REFERENCES public.ci_builds(id) ON DELETE CASCADE;


--
-- Name: vulnerability_occurrence_identifiers fk_rails_e4ef6d027c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vulnerability_occurrence_identifiers
    ADD CONSTRAINT fk_rails_e4ef6d027c FOREIGN KEY (occurrence_id) REFERENCES public.vulnerability_occurrences(id) ON DELETE CASCADE;


--
-- Name: approval_merge_request_rule_sources fk_rails_e605a04f76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_merge_request_rule_sources
    ADD CONSTRAINT fk_rails_e605a04f76 FOREIGN KEY (approval_merge_request_rule_id) REFERENCES public.approval_merge_request_rules(id) ON DELETE CASCADE;


--
-- Name: prometheus_alerts fk_rails_e6351447ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alerts
    ADD CONSTRAINT fk_rails_e6351447ec FOREIGN KEY (prometheus_metric_id) REFERENCES public.prometheus_metrics(id) ON DELETE CASCADE;


--
-- Name: merge_request_metrics fk_rails_e6d7c24d1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_metrics
    ADD CONSTRAINT fk_rails_e6d7c24d1b FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: draft_notes fk_rails_e753681674; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.draft_notes
    ADD CONSTRAINT fk_rails_e753681674 FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: merge_request_blocks fk_rails_e9387863bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_request_blocks
    ADD CONSTRAINT fk_rails_e9387863bc FOREIGN KEY (blocking_merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- Name: protected_branch_unprotect_access_levels fk_rails_e9eb8dc025; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.protected_branch_unprotect_access_levels
    ADD CONSTRAINT fk_rails_e9eb8dc025 FOREIGN KEY (protected_branch_id) REFERENCES public.protected_branches(id) ON DELETE CASCADE;


--
-- Name: label_priorities fk_rails_ef916d14fa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.label_priorities
    ADD CONSTRAINT fk_rails_ef916d14fa FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: fork_network_members fk_rails_efccadc4ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fork_network_members
    ADD CONSTRAINT fk_rails_efccadc4ec FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: prometheus_alerts fk_rails_f0e8db86aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prometheus_alerts
    ADD CONSTRAINT fk_rails_f0e8db86aa FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: import_export_uploads fk_rails_f129140f9e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.import_export_uploads
    ADD CONSTRAINT fk_rails_f129140f9e FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: ci_pipeline_chat_data fk_rails_f300456b63; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_pipeline_chat_data
    ADD CONSTRAINT fk_rails_f300456b63 FOREIGN KEY (chat_name_id) REFERENCES public.chat_names(id) ON DELETE CASCADE;


--
-- Name: approval_project_rules_users fk_rails_f365da8250; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.approval_project_rules_users
    ADD CONSTRAINT fk_rails_f365da8250 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: insights fk_rails_f36fda3932; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insights
    ADD CONSTRAINT fk_rails_f36fda3932 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: board_group_recent_visits fk_rails_f410736518; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_group_recent_visits
    ADD CONSTRAINT fk_rails_f410736518 FOREIGN KEY (group_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: internal_ids fk_rails_f7d46b66c6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.internal_ids
    ADD CONSTRAINT fk_rails_f7d46b66c6 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_requests_closing_issues fk_rails_f8540692be; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_requests_closing_issues
    ADD CONSTRAINT fk_rails_f8540692be FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: ci_build_trace_section_names fk_rails_f8cd72cd26; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_build_trace_section_names
    ADD CONSTRAINT fk_rails_f8cd72cd26 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: merge_trains fk_rails_f90820cb08; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_trains
    ADD CONSTRAINT fk_rails_f90820cb08 FOREIGN KEY (pipeline_id) REFERENCES public.ci_pipelines(id) ON DELETE SET NULL;


--
-- Name: ci_runner_namespaces fk_rails_f9d9ed3308; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_runner_namespaces
    ADD CONSTRAINT fk_rails_f9d9ed3308 FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: board_project_recent_visits fk_rails_fb6fc419cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.board_project_recent_visits
    ADD CONSTRAINT fk_rails_fb6fc419cb FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: cluster_groups fk_rails_fdb8648a96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster_groups
    ADD CONSTRAINT fk_rails_fdb8648a96 FOREIGN KEY (cluster_id) REFERENCES public.clusters(id) ON DELETE CASCADE;


--
-- Name: project_tracing_settings fk_rails_fe56f57fc6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_tracing_settings
    ADD CONSTRAINT fk_rails_fe56f57fc6 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: resource_label_events fk_rails_fe91ece594; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resource_label_events
    ADD CONSTRAINT fk_rails_fe91ece594 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: ci_builds_metadata fk_rails_ffcf702a02; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ci_builds_metadata
    ADD CONSTRAINT fk_rails_ffcf702a02 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: timelogs fk_timelogs_issues_issue_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelogs
    ADD CONSTRAINT fk_timelogs_issues_issue_id FOREIGN KEY (issue_id) REFERENCES public.issues(id) ON DELETE CASCADE;


--
-- Name: timelogs fk_timelogs_merge_requests_merge_request_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timelogs
    ADD CONSTRAINT fk_timelogs_merge_requests_merge_request_id FOREIGN KEY (merge_request_id) REFERENCES public.merge_requests(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20171230123729'),
('20180101160629'),
('20180101160630'),
('20180102220145'),
('20180103123548'),
('20180104131052'),
('20180105212544'),
('20180109183319'),
('20180113220114'),
('20180115094742'),
('20180115113902'),
('20180115201419'),
('20180116193854'),
('20180119121225'),
('20180119135717'),
('20180119160751'),
('20180122154930'),
('20180122162010'),
('20180125214301'),
('20180129193323'),
('20180201102129'),
('20180201110056'),
('20180201145907'),
('20180204200836'),
('20180206200543'),
('20180208183958'),
('20180209115333'),
('20180209165249'),
('20180212030105'),
('20180212101828'),
('20180212101928'),
('20180212102028'),
('20180213131630'),
('20180214093516'),
('20180214155405'),
('20180215181245'),
('20180216120000'),
('20180216120010'),
('20180216120020'),
('20180216120030'),
('20180216120040'),
('20180216120050'),
('20180216121020'),
('20180216121030'),
('20180219153455'),
('20180220150310'),
('20180221151752'),
('20180222043024'),
('20180223120443'),
('20180223124427'),
('20180223144945'),
('20180226050030'),
('20180227182112'),
('20180228172924'),
('20180301010859'),
('20180301084653'),
('20180302152117'),
('20180305095250'),
('20180305100050'),
('20180305144721'),
('20180306074045'),
('20180306134842'),
('20180306164012'),
('20180307012445'),
('20180308052825'),
('20180308125206'),
('20180309121820'),
('20180309160427'),
('20180314100728'),
('20180314145917'),
('20180315160435'),
('20180319190020'),
('20180320182229'),
('20180323150945'),
('20180326202229'),
('20180327101207'),
('20180330121048'),
('20180403035759'),
('20180405101928'),
('20180405142733'),
('20180406204716'),
('20180408143354'),
('20180408143355'),
('20180409170809'),
('20180413022611'),
('20180416155103'),
('20180417090132'),
('20180417101040'),
('20180417101940'),
('20180418053107'),
('20180420010016'),
('20180420010616'),
('20180420080616'),
('20180423204600'),
('20180424090541'),
('20180424134533'),
('20180424151928'),
('20180424160449'),
('20180425075446'),
('20180425131009'),
('20180425205249'),
('20180426102016'),
('20180430101916'),
('20180430143705'),
('20180502122856'),
('20180503131624'),
('20180503141722'),
('20180503150427'),
('20180503175053'),
('20180503175054'),
('20180503193542'),
('20180503193953'),
('20180503200320'),
('20180504195842'),
('20180507083701'),
('20180508055821'),
('20180508100222'),
('20180508102840'),
('20180508135515'),
('20180511090724'),
('20180511131058'),
('20180511174224'),
('20180512061621'),
('20180514161336'),
('20180515005612'),
('20180515121227'),
('20180517082340'),
('20180521171529'),
('20180523042841'),
('20180523125103'),
('20180524132016'),
('20180529093006'),
('20180529152628'),
('20180530135500'),
('20180531185349'),
('20180531220618'),
('20180601213245'),
('20180603190921'),
('20180604123514'),
('20180607071808'),
('20180608091413'),
('20180608110058'),
('20180608201435'),
('20180612103626'),
('20180613081317'),
('20180625113853'),
('20180626125654'),
('20180628124813'),
('20180629153018'),
('20180629191052'),
('20180702120647'),
('20180702124358'),
('20180702134423'),
('20180704145007'),
('20180704204006'),
('20180705160945'),
('20180706223200'),
('20180710162338'),
('20180711103851'),
('20180711103922'),
('20180713092803'),
('20180717125853'),
('20180718005113'),
('20180720023512'),
('20180722103201'),
('20180723135214'),
('20180726172057'),
('20180807153545'),
('20180808162000'),
('20180809195358'),
('20180813101999'),
('20180813102000'),
('20180814153625'),
('20180815040323'),
('20180815160409'),
('20180815170510'),
('20180815175440'),
('20180816161409'),
('20180816193530'),
('20180826111825'),
('20180831164904'),
('20180831164905'),
('20180831164907'),
('20180831164908'),
('20180831164909'),
('20180831164910'),
('20180901171833'),
('20180901200537'),
('20180906101639'),
('20180907015926'),
('20180910115836'),
('20180910153412'),
('20180910153413'),
('20180912111628'),
('20180913142237'),
('20180914162043'),
('20180914201132'),
('20180916011959'),
('20180917172041'),
('20180924141949'),
('20180924190739'),
('20180924201039'),
('20180925200829'),
('20180927073410'),
('20181002172433'),
('20181005110927'),
('20181005125926'),
('20181006004100'),
('20181008145341'),
('20181008145359'),
('20181008200441'),
('20181009190428'),
('20181010133639'),
('20181010235606'),
('20181013005024'),
('20181014203236'),
('20181015155839'),
('20181016141739'),
('20181016152238'),
('20181017001059'),
('20181019032400'),
('20181019032408'),
('20181019105553'),
('20181022135539'),
('20181022173835'),
('20181023104858'),
('20181023144439'),
('20181025115728'),
('20181026091631'),
('20181026143227'),
('20181027114222'),
('20181028120717'),
('20181030135124'),
('20181030154446'),
('20181031145139'),
('20181031190558'),
('20181031190559'),
('20181101091005'),
('20181101091124'),
('20181101144347'),
('20181101191341'),
('20181105201455'),
('20181106135939'),
('20181107054254'),
('20181108091549'),
('20181112103239'),
('20181115140140'),
('20181116050532'),
('20181116141415'),
('20181116141504'),
('20181119081539'),
('20181119132520'),
('20181120082911'),
('20181120091639'),
('20181120151656'),
('20181121101842'),
('20181121101843'),
('20181121111200'),
('20181122160027'),
('20181123042307'),
('20181123135036'),
('20181123144235'),
('20181126150622'),
('20181126153547'),
('20181128123704'),
('20181129104854'),
('20181129104944'),
('20181130102132'),
('20181203002526'),
('20181205171941'),
('20181211092510'),
('20181211092514'),
('20181212104941'),
('20181212171634'),
('20181219130552'),
('20181219145520'),
('20181219145521'),
('20181228175414'),
('20190102152410'),
('20190103140724'),
('20190104182041'),
('20190107151020'),
('20190108192941'),
('20190109153125'),
('20190114172110'),
('20190115054215'),
('20190115054216'),
('20190115092821'),
('20190116234221'),
('20190124200344'),
('20190130091630'),
('20190131122559'),
('20190204115450'),
('20190206193120'),
('20190211131150'),
('20190214112022'),
('20190215154930'),
('20190218134158'),
('20190218134209'),
('20190220142344'),
('20190220150130'),
('20190222051615'),
('20190225152525'),
('20190225160300'),
('20190225160301'),
('20190228192410'),
('20190301081611'),
('20190301182457'),
('20190312071108'),
('20190312113229'),
('20190312113634'),
('20190313092516'),
('20190315191339'),
('20190320174702'),
('20190322132835'),
('20190322164830'),
('20190325080727'),
('20190325105715'),
('20190325111602'),
('20190325165127'),
('20190326164045'),
('20190327163904'),
('20190329085614'),
('20190402150158'),
('20190402224749'),
('20190403161806'),
('20190404143330'),
('20190404231137'),
('20190408163745'),
('20190409224933'),
('20190410173409'),
('20190412155659'),
('20190412183653'),
('20190414185432'),
('20190415030217'),
('20190415095825'),
('20190415172035'),
('20190416185130'),
('20190416213556'),
('20190416213615'),
('20190416213631'),
('20190418132125'),
('20190418132750'),
('20190418182545'),
('20190419121952'),
('20190419123057'),
('20190422082247'),
('20190423124640'),
('20190424134256'),
('20190426180107'),
('20190429082448'),
('20190430131225'),
('20190430142025'),
('20190506135337'),
('20190506135400'),
('20190511144331'),
('20190513174947'),
('20190514105711'),
('20190515125613'),
('20190516011213'),
('20190516151857'),
('20190516155724'),
('20190517153211'),
('20190520200123'),
('20190520201748'),
('20190521174505'),
('20190522143720'),
('20190523112344'),
('20190524062810'),
('20190524071727'),
('20190524073827'),
('20190527011309'),
('20190527194830'),
('20190527194900'),
('20190528173628'),
('20190528180441'),
('20190529142545'),
('20190530042141'),
('20190530154715'),
('20190531153110'),
('20190602014139'),
('20190603124955'),
('20190604091310'),
('20190604184643'),
('20190605104727'),
('20190605184422'),
('20190606014128'),
('20190606034427'),
('20190606054649'),
('20190606054742'),
('20190606054832'),
('20190606163724'),
('20190606175050'),
('20190607085356'),
('20190607145325'),
('20190607190856'),
('20190607205656'),
('20190610142825'),
('20190611090827'),
('20190611161641'),
('20190611161642'),
('20190613030606'),
('20190613044655'),
('20190613073003'),
('20190613231640'),
('20190617123615'),
('20190618171120'),
('20190619175843'),
('20190620112608'),
('20190621022810'),
('20190621151636'),
('20190623212503'),
('20190624123615'),
('20190625115224'),
('20190625184066'),
('20190627051902'),
('20190628145246'),
('20190628185000'),
('20190628185004'),
('20190703130053');


