{{/*
Generate chart name.
*/}}
{{- define "sample-nodejs.name" -}}
{{- .Chart.Name }}
{{- end }}


{{/*
Generate full resource name.
*/}}
{{- define "sample-nodejs.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "sample-nodejs.name" .) }}
{{- end }}


{{/*
Common labels.
*/}}
{{- define "sample-nodejs.labels" -}}
app.kubernetes.io/name: {{ include "sample-nodejs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Selector labels.
*/}}
{{- define "sample-nodejs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "sample-nodejs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}