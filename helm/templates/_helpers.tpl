{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "clickhouse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
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


{{/*
Create clickhouse log path.
if .Values.clickhouse.config.logger.path is empty, default value "/var/log/clickhouse-server".
*/}}
{{- define "clickhouse.logpath" -}}
{{- if .Values.clickhouse.config.logs.logger.log -}}
{{- .Values.clickhouse.config.logs.logger.log | dir | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" "/var/log/clickhouse-server" -}}
{{- end -}}
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
