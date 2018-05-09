SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
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


SET default_tablespace = '';

SET default_with_oids = false;

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
-- Name: building_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.building_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: building_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.building_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.building_types_id_seq OWNED BY public.building_types.id;


--
-- Name: cl_scenarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cl_scenarios (
    id bigint NOT NULL,
    name character varying,
    algorithm character varying,
    kappa integer,
    starttime timestamp without time zone,
    endtime timestamp without time zone,
    interval_id bigint,
    clustering_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);


--
-- Name: cl_scenarios_consumers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cl_scenarios_consumers (
    consumer_id bigint NOT NULL,
    cl_scenario_id bigint NOT NULL
);


--
-- Name: cl_scenarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cl_scenarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cl_scenarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cl_scenarios_id_seq OWNED BY public.cl_scenarios.id;


--
-- Name: clusterings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clusterings (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: clusterings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clusterings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clusterings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clusterings_id_seq OWNED BY public.clusterings.id;


--
-- Name: communities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities (
    id bigint NOT NULL,
    name character varying,
    description text,
    clustering_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: communities_consumers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.communities_consumers (
    consumer_id bigint NOT NULL,
    community_id bigint NOT NULL
);


--
-- Name: communities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.communities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: communities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.communities_id_seq OWNED BY public.communities.id;


--
-- Name: connection_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.connection_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: connection_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.connection_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: connection_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.connection_types_id_seq OWNED BY public.connection_types.id;


--
-- Name: consumer_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consumer_categories (
    id bigint NOT NULL,
    name character varying,
    description text,
    real_time boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: consumer_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.consumer_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consumer_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.consumer_categories_id_seq OWNED BY public.consumer_categories.id;


--
-- Name: consumers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consumers (
    id bigint NOT NULL,
    name character varying,
    location character varying,
    edms_id character varying,
    building_type_id bigint,
    connection_type_id bigint,
    location_x double precision,
    location_y double precision,
    feeder_id character varying,
    consumer_category_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: consumers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.consumers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consumers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.consumers_id_seq OWNED BY public.consumers.id;


--
-- Name: consumers_recommendations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consumers_recommendations (
    recommendation_id bigint NOT NULL,
    consumer_id bigint NOT NULL
);


--
-- Name: consumers_scenarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consumers_scenarios (
    scenario_id bigint NOT NULL,
    consumer_id bigint NOT NULL
);


--
-- Name: consumers_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consumers_users (
    consumer_id bigint NOT NULL,
    user_id bigint NOT NULL
);


--
-- Name: data_points; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_points (
    id bigint NOT NULL,
    consumer_id bigint,
    interval_id bigint,
    "timestamp" timestamp without time zone,
    consumption double precision,
    flexibility double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: data_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_points_id_seq OWNED BY public.data_points.id;


--
-- Name: ecc_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ecc_types (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ecc_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ecc_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ecc_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ecc_types_id_seq OWNED BY public.ecc_types.id;


--
-- Name: energy_programs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.energy_programs (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: energy_programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.energy_programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: energy_programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.energy_programs_id_seq OWNED BY public.energy_programs.id;


--
-- Name: energy_programs_scenarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.energy_programs_scenarios (
    scenario_id bigint NOT NULL,
    energy_program_id bigint NOT NULL
);


--
-- Name: flexibilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flexibilities (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: flexibilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flexibilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flexibilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flexibilities_id_seq OWNED BY public.flexibilities.id;


--
-- Name: intervals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.intervals (
    id bigint NOT NULL,
    name character varying,
    duration integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: intervals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.intervals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: intervals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.intervals_id_seq OWNED BY public.intervals.id;


--
-- Name: recommendation_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recommendation_types (
    id bigint NOT NULL,
    name character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: recommendation_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recommendation_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recommendation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recommendation_types_id_seq OWNED BY public.recommendation_types.id;


--
-- Name: recommendations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recommendations (
    id bigint NOT NULL,
    status integer DEFAULT 0,
    recommendation_type_id bigint,
    scenario_id bigint,
    parameter character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recommendations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recommendations_id_seq OWNED BY public.recommendations.id;


--
-- Name: results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.results (
    id bigint NOT NULL,
    scenario_id bigint,
    energy_program_id bigint,
    "timestamp" timestamp without time zone,
    energy_cost double precision,
    user_welfare double precision,
    retailer_profit double precision,
    total_welfare double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.results_id_seq OWNED BY public.results.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying,
    resource_type character varying,
    resource_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: scenarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scenarios (
    id bigint NOT NULL,
    name character varying,
    starttime timestamp without time zone,
    endtime timestamp without time zone,
    interval_id bigint,
    ecc_type_id bigint,
    energy_cost_parameter double precision,
    profit_margin_parameter double precision,
    flexibility_id bigint,
    gamma_parameter double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    stderr text,
    user_id bigint,
    error_message character varying
);


--
-- Name: scenarios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scenarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scenarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scenarios_id_seq OWNED BY public.scenarios.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    authentication_token character varying(30),
    provider character varying,
    uid character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
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
-- Name: users_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_roles (
    user_id bigint,
    role_id bigint
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_types ALTER COLUMN id SET DEFAULT nextval('public.building_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cl_scenarios ALTER COLUMN id SET DEFAULT nextval('public.cl_scenarios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusterings ALTER COLUMN id SET DEFAULT nextval('public.clusterings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities ALTER COLUMN id SET DEFAULT nextval('public.communities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_types ALTER COLUMN id SET DEFAULT nextval('public.connection_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consumer_categories ALTER COLUMN id SET DEFAULT nextval('public.consumer_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consumers ALTER COLUMN id SET DEFAULT nextval('public.consumers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_points ALTER COLUMN id SET DEFAULT nextval('public.data_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ecc_types ALTER COLUMN id SET DEFAULT nextval('public.ecc_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.energy_programs ALTER COLUMN id SET DEFAULT nextval('public.energy_programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flexibilities ALTER COLUMN id SET DEFAULT nextval('public.flexibilities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intervals ALTER COLUMN id SET DEFAULT nextval('public.intervals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendation_types ALTER COLUMN id SET DEFAULT nextval('public.recommendation_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations ALTER COLUMN id SET DEFAULT nextval('public.recommendations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results ALTER COLUMN id SET DEFAULT nextval('public.results_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scenarios ALTER COLUMN id SET DEFAULT nextval('public.scenarios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: building_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_types
    ADD CONSTRAINT building_types_pkey PRIMARY KEY (id);


--
-- Name: cl_scenarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cl_scenarios
    ADD CONSTRAINT cl_scenarios_pkey PRIMARY KEY (id);


--
-- Name: clusterings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clusterings
    ADD CONSTRAINT clusterings_pkey PRIMARY KEY (id);


--
-- Name: communities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT communities_pkey PRIMARY KEY (id);


--
-- Name: connection_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.connection_types
    ADD CONSTRAINT connection_types_pkey PRIMARY KEY (id);


--
-- Name: consumer_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consumer_categories
    ADD CONSTRAINT consumer_categories_pkey PRIMARY KEY (id);


--
-- Name: consumers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT consumers_pkey PRIMARY KEY (id);


--
-- Name: data_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_points
    ADD CONSTRAINT data_points_pkey PRIMARY KEY (id);


--
-- Name: ecc_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ecc_types
    ADD CONSTRAINT ecc_types_pkey PRIMARY KEY (id);


--
-- Name: energy_programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.energy_programs
    ADD CONSTRAINT energy_programs_pkey PRIMARY KEY (id);


--
-- Name: flexibilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flexibilities
    ADD CONSTRAINT flexibilities_pkey PRIMARY KEY (id);


--
-- Name: intervals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.intervals
    ADD CONSTRAINT intervals_pkey PRIMARY KEY (id);


--
-- Name: recommendation_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendation_types
    ADD CONSTRAINT recommendation_types_pkey PRIMARY KEY (id);


--
-- Name: recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT recommendations_pkey PRIMARY KEY (id);


--
-- Name: results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: scenarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scenarios
    ADD CONSTRAINT scenarios_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cons_rec; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cons_rec ON public.consumers_recommendations USING btree (consumer_id, recommendation_id);


--
-- Name: index_cl_scenarios_consumers_on_cl_scenario_id_and_consumer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cl_scenarios_consumers_on_cl_scenario_id_and_consumer_id ON public.cl_scenarios_consumers USING btree (cl_scenario_id, consumer_id);


--
-- Name: index_cl_scenarios_consumers_on_consumer_id_and_cl_scenario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cl_scenarios_consumers_on_consumer_id_and_cl_scenario_id ON public.cl_scenarios_consumers USING btree (consumer_id, cl_scenario_id);


--
-- Name: index_cl_scenarios_on_clustering_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cl_scenarios_on_clustering_id ON public.cl_scenarios USING btree (clustering_id);


--
-- Name: index_cl_scenarios_on_interval_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cl_scenarios_on_interval_id ON public.cl_scenarios USING btree (interval_id);


--
-- Name: index_cl_scenarios_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cl_scenarios_on_user_id ON public.cl_scenarios USING btree (user_id);


--
-- Name: index_communities_consumers_on_community_id_and_consumer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_consumers_on_community_id_and_consumer_id ON public.communities_consumers USING btree (community_id, consumer_id);


--
-- Name: index_communities_consumers_on_consumer_id_and_community_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_consumers_on_consumer_id_and_community_id ON public.communities_consumers USING btree (consumer_id, community_id);


--
-- Name: index_communities_on_clustering_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_communities_on_clustering_id ON public.communities USING btree (clustering_id);


--
-- Name: index_consumers_on_building_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consumers_on_building_type_id ON public.consumers USING btree (building_type_id);


--
-- Name: index_consumers_on_connection_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consumers_on_connection_type_id ON public.consumers USING btree (connection_type_id);


--
-- Name: index_consumers_on_consumer_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consumers_on_consumer_category_id ON public.consumers USING btree (consumer_category_id);


--
-- Name: index_consumers_scenarios_on_consumer_id_and_scenario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_consumers_scenarios_on_consumer_id_and_scenario_id ON public.consumers_scenarios USING btree (consumer_id, scenario_id);


--
-- Name: index_consumers_scenarios_on_scenario_id_and_consumer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_consumers_scenarios_on_scenario_id_and_consumer_id ON public.consumers_scenarios USING btree (scenario_id, consumer_id);


--
-- Name: index_data_points_on_consumer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_points_on_consumer_id ON public.data_points USING btree (consumer_id);


--
-- Name: index_data_points_on_interval_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_points_on_interval_id ON public.data_points USING btree (interval_id);


--
-- Name: index_data_points_on_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_points_on_timestamp ON public.data_points USING btree ("timestamp");


--
-- Name: index_data_points_on_timestamp_and_consumer_id_and_interval_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_data_points_on_timestamp_and_consumer_id_and_interval_id ON public.data_points USING btree ("timestamp", consumer_id, interval_id);


--
-- Name: index_energy_program_scenario; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_energy_program_scenario ON public.energy_programs_scenarios USING btree (energy_program_id, scenario_id);


--
-- Name: index_recommendations_on_recommendation_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recommendations_on_recommendation_type_id ON public.recommendations USING btree (recommendation_type_id);


--
-- Name: index_recommendations_on_scenario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recommendations_on_scenario_id ON public.recommendations USING btree (scenario_id);


--
-- Name: index_results_on_energy_program_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_energy_program_id ON public.results USING btree (energy_program_id);


--
-- Name: index_results_on_scenario_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_results_on_scenario_id ON public.results USING btree (scenario_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name ON public.roles USING btree (name);


--
-- Name: index_roles_on_name_and_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_name_and_resource_type_and_resource_id ON public.roles USING btree (name, resource_type, resource_id);


--
-- Name: index_roles_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_resource_type_and_resource_id ON public.roles USING btree (resource_type, resource_id);


--
-- Name: index_scenario_energy_program; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_scenario_energy_program ON public.energy_programs_scenarios USING btree (scenario_id, energy_program_id);


--
-- Name: index_scenarios_on_ecc_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scenarios_on_ecc_type_id ON public.scenarios USING btree (ecc_type_id);


--
-- Name: index_scenarios_on_flexibility_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scenarios_on_flexibility_id ON public.scenarios USING btree (flexibility_id);


--
-- Name: index_scenarios_on_interval_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scenarios_on_interval_id ON public.scenarios USING btree (interval_id);


--
-- Name: index_scenarios_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scenarios_on_user_id ON public.scenarios USING btree (user_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON public.users USING btree (authentication_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_roles_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_roles_on_role_id ON public.users_roles USING btree (role_id);


--
-- Name: index_users_roles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_roles_on_user_id ON public.users_roles USING btree (user_id);


--
-- Name: index_users_roles_on_user_id_and_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_roles_on_user_id_and_role_id ON public.users_roles USING btree (user_id, role_id);


--
-- Name: rec_cons; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rec_cons ON public.consumers_recommendations USING btree (recommendation_id, consumer_id);


--
-- Name: fk_rails_07833f7155; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_points
    ADD CONSTRAINT fk_rails_07833f7155 FOREIGN KEY (interval_id) REFERENCES public.intervals(id);


--
-- Name: fk_rails_2b230cc1aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scenarios
    ADD CONSTRAINT fk_rails_2b230cc1aa FOREIGN KEY (interval_id) REFERENCES public.intervals(id);


--
-- Name: fk_rails_529abe4372; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT fk_rails_529abe4372 FOREIGN KEY (scenario_id) REFERENCES public.scenarios(id);


--
-- Name: fk_rails_7000fa6753; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_points
    ADD CONSTRAINT fk_rails_7000fa6753 FOREIGN KEY (consumer_id) REFERENCES public.consumers(id);


--
-- Name: fk_rails_7c12260342; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cl_scenarios
    ADD CONSTRAINT fk_rails_7c12260342 FOREIGN KEY (interval_id) REFERENCES public.intervals(id);


--
-- Name: fk_rails_7c59c69dc8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cl_scenarios
    ADD CONSTRAINT fk_rails_7c59c69dc8 FOREIGN KEY (clustering_id) REFERENCES public.clusterings(id);


--
-- Name: fk_rails_7d4c726ffa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_7d4c726ffa FOREIGN KEY (energy_program_id) REFERENCES public.energy_programs(id);


--
-- Name: fk_rails_82e684e457; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recommendations
    ADD CONSTRAINT fk_rails_82e684e457 FOREIGN KEY (recommendation_type_id) REFERENCES public.recommendation_types(id);


--
-- Name: fk_rails_990be260f2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scenarios
    ADD CONSTRAINT fk_rails_990be260f2 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_9e230f26a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scenarios
    ADD CONSTRAINT fk_rails_9e230f26a7 FOREIGN KEY (flexibility_id) REFERENCES public.flexibilities(id);


--
-- Name: fk_rails_ada67cd0c1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cl_scenarios
    ADD CONSTRAINT fk_rails_ada67cd0c1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_c10f0e5812; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scenarios
    ADD CONSTRAINT fk_rails_c10f0e5812 FOREIGN KEY (ecc_type_id) REFERENCES public.ecc_types(id);


--
-- Name: fk_rails_cd6312d696; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.communities
    ADD CONSTRAINT fk_rails_cd6312d696 FOREIGN KEY (clustering_id) REFERENCES public.clusterings(id);


--
-- Name: fk_rails_ced84d023f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT fk_rails_ced84d023f FOREIGN KEY (building_type_id) REFERENCES public.building_types(id);


--
-- Name: fk_rails_f512f39237; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT fk_rails_f512f39237 FOREIGN KEY (connection_type_id) REFERENCES public.connection_types(id);


--
-- Name: fk_rails_f6a27b028e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_rails_f6a27b028e FOREIGN KEY (scenario_id) REFERENCES public.scenarios(id);


--
-- Name: fk_rails_f95f66f425; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consumers
    ADD CONSTRAINT fk_rails_f95f66f425 FOREIGN KEY (consumer_category_id) REFERENCES public.consumer_categories(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170907111549'),
('20170907111613'),
('20170908083811'),
('20170918133505'),
('20170919121910'),
('20170919130422'),
('20170919132647'),
('20170920125628'),
('20170920125912'),
('20170920125956'),
('20170920130203'),
('20170920130257'),
('20171018092646'),
('20171023083033'),
('20171023083311'),
('20171023091650'),
('20171023091821'),
('20171106130507'),
('20171106153000'),
('20171106154000'),
('20171115124238'),
('20171120082548'),
('20171120103124'),
('20171121135634'),
('20171204152213'),
('20171204152703'),
('20171204165556'),
('20171218135610'),
('20180213144538'),
('20180213145936'),
('20180213152751'),
('20180214094548'),
('20180221094029');


