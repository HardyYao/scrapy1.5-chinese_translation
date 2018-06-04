# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
<<<<<<< HEAD
SPHINXPROJ    = my_project
SOURCEDIR     = .
BUILDDIR      = _build
=======
SPHINXPROJ    = translation
SOURCEDIR     = .
BUILDDIR      = build
>>>>>>> 065817c4dd1c333715d0dcc744c754a3a2a1f0d6

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
<<<<<<< HEAD
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
=======
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
>>>>>>> 065817c4dd1c333715d0dcc744c754a3a2a1f0d6
