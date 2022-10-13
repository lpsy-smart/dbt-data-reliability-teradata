{%- macro upload_dbt_snapshots() -%}
    {% set relation = elementary.get_elementary_relation('dbt_snapshots') %}
    {% set edr_cli_run = elementary.get_config_var('edr_cli_run') %}
    {% if execute and not edr_cli_run %}
        {% set snapshots = graph.nodes.values() | selectattr('resource_type', '==', 'snapshot') %}
        {% do elementary.upload_csv_artifacts_to_table(relation, snapshots, elementary.get_flatten_model_callback()) %}
    {%- endif -%}
    {{- return('') -}}
{%- endmacro -%}
