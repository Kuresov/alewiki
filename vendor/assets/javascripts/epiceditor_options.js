var opts = {
  container: 'epiceditor',
  basePath: 'http://localhost:3000/',
  clientSideStorage: true,
  localStorageName: 'epiceditor',
  textarea: 'prev',
  useNativeFullscreen: true,
  parser: marked,
  file: {
    name: 'epiceditor',
    defaultContent: '',
    autoSave: 100
  },
  theme: {
    base: 'themes/base/epiceditor.css',
    preview: 'themes/preview/preview-dark.css',
    editor: 'themes/editor/epic-dark.css'
  },
  button: {
    preview: false,
    fullscreen: false,
    bar: "auto"
  },
  shortcut: {
    modifier: 18,
    fullscreen: 70,
    preview: 80
  },
  string: {
    togglePreview: 'Toggle Preview Mode',
    toggleEdit: 'Toggle Edit Mode',
    toggleFullscreen: 'Enter Fullscreen'
  },
  autogrow: true
}
