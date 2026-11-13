{{- define "service.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "service.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
{{- end -}}

{{- define "service.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{ include "service.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "service.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
