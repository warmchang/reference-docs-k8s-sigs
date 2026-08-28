{{ define "packages" -}}

{{- range $idx, $val := .packages -}}
{{- if .IsPrimary -}}
---
title: {{ .Title }}
content_type: tool-reference
package: {{ if .GroupName }}{{ .DisplayName }}{{ else }}{{ .VersionName }}{{ end }}
auto_generated: true
---
{{ .GetComment -}}
{{- end -}}
{{- end }}

## Resource Types 

{{ range .packages -}}
  {{- range .VisibleTypes -}}
    {{- if .IsExported }}
- [{{ .DisplayName }}]({{ .Link }})
    {{- end -}}
  {{- end -}}
{{- end -}}

{{ range .packages }}
  {{ if ne .GroupName "" -}}
    {{/* For package with a group name, list all type definitions in it. */}}
    {{- range .VisibleTypes }}
      {{- if or .Referenced .IsExported -}}
{{ template "type" . }}
      {{- end -}}
    {{ end }}
  {{ else }}
    {{/* For package w/o group name, list only types referenced. */}}
    {{ $pkgTitle := .Title }}
    {{- range .VisibleTypes -}}
      {{- if or .Referenced (eq $pkgTitle "kubeconfig (v1)") -}}
{{ template "type" . }}
      {{- end -}}
    {{- end }}
  {{- end }}
{{- end }}
{{- end }}
