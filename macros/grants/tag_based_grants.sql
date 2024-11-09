{% macro pg_grant_by_tags(role, privilege, include_tags=[], exclude_tags=[]) %}
    {% if execute %}
        {% set models = graph.nodes.values() | selectattr("resource_type", "in", ["model", "seed", "snapshot"]) %}
        
        {% for model in models %}
            {% set model_tags = model.config.get('tags', []) %}
            {% set should_grant = true %}
            
            {# Check include tags #}
            {% if include_tags | length > 0 %}
                {% set should_grant = false %}
                {% for tag in include_tags %}
                    {% if tag in model_tags %}
                        {% set should_grant = true %}
                    {% endif %}
                {% endfor %}
            {% endif %}
            
            {# Check exclude tags #}
            {% for tag in exclude_tags %}
                {% if tag in model_tags %}
                    {% set should_grant = false %}
                {% endif %}
            {% endfor %}
            
            {% if should_grant %}
                {% do pg_grant_core(model.relation, privilege, role) %}
            {% endif %}
        {% endfor %}
    {% endif %}
{% endmacro %} 