# charts/common/templates/_helpers.tpl
# ========================================

{{/*
Expand the name of the chart
*/}}
{{- define "banking.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a full name
*/}}
{{- define "banking.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "banking.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "banking.labels" -}}
app.kubernetes.io/name: {{ include "banking.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "banking.selectorLabels" -}}
app.kubernetes.io/name: {{ include "banking.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}