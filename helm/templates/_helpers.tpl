{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "clickhouse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Рекурсивный генератор XML узлов для ConfigMap */}}
{{- define "clickhouse.render_xml_node" -}}
{{- $parentName := .parentName -}}
{{- $key := .key -}}
{{- $value := .value -}}

{{- if kindIs "map" $value -}}
<{{ $key }}>
{{- range $subKey, $subValue := $value }}
{{ include "clickhouse.render_xml_node" (dict "parentName" $parentName "key" $subKey "value" $subValue) | indent 2 }}
{{- end }}
</{{ $key }}>
{{- else if hasSuffix "password" $key -}}
{{- $envPrefix := $parentName | upper | replace "-" "_" -}}
{{- $envKey := $key | upper -}}
<{{ $key }} from_env="{{ $envPrefix }}_NMD_{{ $envKey }}" />
{{- else -}}
<{{ $key }}>{{ $value }}</{{ $key }}>
{{- end -}}
{{- end -}}

{{/* Поиск и кодирование паролей для Secret */}}
{{- define "clickhouse.render_secret_passwords" -}}
{{- $parentName := .parentName -}}
{{- $key := .key -}}
{{- $value := .value -}}

{{- if kindIs "map" $value -}}
  {{- range $subKey, $subValue := $value }}
    {{- include "clickhouse.render_secret_passwords" (dict "parentName" $parentName "key" $subKey "value" $subValue) }}
  {{- end }}
{{- else if hasSuffix "password" $key -}}
  {{- if $value -}}
    {{- $envPrefix := $parentName | upper | replace "-" "_" -}}
    {{- $envKey := $key | upper -}}
{{ printf "%s_NMD_%s" $envPrefix $envKey }}: {{ $value | toString | b64enc }}
{{ end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "clickhouse.fullname" -}}
    {{- if .Values.fullnameOverride -}}
        {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
    {{- else if .Values.fullNameClassic -}}
        {{- $name := default .Chart.Name .Values.nameOverride -}}
        {{- if contains $name .Release.Name -}}
            {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
        {{- else -}}
            {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
        {{- end -}}
    {{- else -}}
        {{- print "clickhouse" -}}
    {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "clickhouse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}



{{- define "clickhouse-keeper.fullname" -}}
{{- if .Values.fullnameOverride -}}
  {{- $postfix := "keeper" -}}
  {{- printf "%s-%s" $postfix .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.fullNameClassic -}}
  {{- $name := default .Chart.Name .Values.nameOverride -}}
  {{- $postfix := "keeper" -}}
  {{- if contains $name .Release.Name -}}
    {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- printf "%s-%s-%s" .Release.Name $name $postfix | trunc 63 | trimSuffix "-" -}}
  {{- end -}}
{{- else -}}
  {{- print "clickhouse-keeper" -}}
{{- end -}}
{{- end -}}


{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
