{{/*
Expand the name of the chart.
*/}}
{{- define "kafkahelmdeploy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafkahelmdeploy.fullname" -}}
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
{{- define "kafkahelmdeploy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kafkahelmdeploy.kafkalabels" -}}
app.kubernetes.io/name: kafka
app.kubernetes.io/instance: kafka1
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/component: kafka
app.kubernetes.io/part-of: confluentkafka
helm.sh/chart: {{ include "kafkahelmdeploy.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "kafkahelmdeploy.zookeeperlabels" -}}
app.kubernetes.io/name: zookeeper
app.kubernetes.io/instance: zookeeper1
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/component: zookeeper
app.kubernetes.io/part-of: confluentkafka
helm.sh/chart: {{ include "kafkahelmdeploy.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "kafkahelmdeploy.connectlabels" -}}
app.kubernetes.io/name: connect
app.kubernetes.io/instance: connect1
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/component: connect
app.kubernetes.io/part-of: confluentkafka
helm.sh/chart: {{ include "kafkahelmdeploy.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "kafkahelmdeploy.kafkaselectors" -}}
app.kubernetes.io/name: kafka
app.kubernetes.io/instance: kafka1
{{- end }}

{{- define "kafkahelmdeploy.zookeeperselectors" -}}
app.kubernetes.io/name: zookeeper
app.kubernetes.io/instance: zookeeper1
{{- end }}

{{- define "kafkahelmdeploy.nodeselectorlabels" -}}
appname: kafka
{{- end }}

{{- define "kafkahelmdeploy.connectselectors" -}}
app.kubernetes.io/name: connect
app.kubernetes.io/instance: connect1
{{- end }}
