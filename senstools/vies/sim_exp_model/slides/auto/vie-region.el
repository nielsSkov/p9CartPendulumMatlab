(TeX-add-style-hook "vie-region"
 (function
  (lambda ()
    (LaTeX-add-environments
     "Saet")
    (TeX-add-symbols
     "argmin")
    (TeX-run-style-hooks
     "amsmath"
     "amsfonts"
     "amssymb"
     "graphicx"
     "theorem"
     "inputenc"
     "latin1"
     "latex2e"
     "prosper10"
     "prosper"
     "pdf"
     "slideColor"))))

