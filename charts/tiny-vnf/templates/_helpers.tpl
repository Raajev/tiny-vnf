{{/*
Expand the name of the chart.
*/}}
{{- define "tiny-vnf.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tiny-vnf.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "tiny-vnf.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tiny-vnf.labels" -}}
helm.sh/chart: {{ include "tiny-vnf.chart" . }}
{{ include "tiny-vnf.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tiny-vnf.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tiny-vnf.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tiny-vnf.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tiny-vnf.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
{{/*
Sets namespace
*/}}
{{- define "tiny-vnf.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}
{{/*
Looks if there's an existing secret and reuse its password. If not it generates
new password and use it.
*/}}
{{- define "tiny-vnf.password" -}}
{{- $secret := (lookup "v1" "Secret" (include "tiny-vnf.namespace" .) (include "tiny-vnf.fullname" .) ) -}}
  {{- if $secret -}}
    {{-  index $secret "data" "admin-password" -}}
  {{- else -}}
    {{- (randAlphaNum 40) | b64enc | quote -}}
  {{- end -}}
{{- end -}}
{{/*
Return the appropriate apiVersion for rbac.
*/}}
{{- define "tiny-vnf.rbac.apiVersion" -}}
  {{- if .Capabilities.APIVersions.Has "rbac.authorization.k8s.io/v1" }}
    {{- print "rbac.authorization.k8s.io/v1" -}}
  {{- else -}}
    {{- print "rbac.authorization.k8s.io/v1beta1" -}}
  {{- end -}}
{{- end -}}
