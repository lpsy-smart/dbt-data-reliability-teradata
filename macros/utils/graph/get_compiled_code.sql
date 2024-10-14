{% macro get_compiled_code(node, as_column_value=false) %}
    {% set compiled_code = adapter.dispatch("get_compiled_code", "elementary")(node) %}
    
    {% if compiled_code is none %}
        {% do return(none) %}
    {% endif%}

    {% set max_column_size = elementary.get_column_size() %}
    {% if as_column_value and max_column_size and compiled_code and compiled_code | length > max_column_size %}
        {% set compiled_code = compiled_code[:(max_column_size*0.8)|int] %}
    {% endif %}
    
    {% do return(compiled_code[:(max_column_size*0.8)|int]) %}
{% endmacro %}

{% macro default__get_compiled_code(node) %}
    {% do return(node.get('compiled_code') or node.get('compiled_sql')) %}
{% endmacro %}

{% macro redshift__get_compiled_code(node) %}
    {% set compiled_code = node.get('compiled_code') or node.get('compiled_sql') %}
    {% if not compiled_code %}
        {% do return(none) %}
    {% else %}
        {% do return(compiled_code.replace("%", "%%")) %}
    {% endif %}
{% endmacro %}

{% macro get_compiled_code_too_long_err_msg() %}
    {% do return("Compiled code is too long.") %}
{% endmacro %}
