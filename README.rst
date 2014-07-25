===========================================================
Converting the C++ Standard Draft Sources from XML to HTML5
===========================================================

This project aims at providing a basic HTML5 rendering of
the C++ Standard Draft Sources.
The conversion is performed in two steps from the original
LaTeX sources:

#. LaTeX to XML conversion. Performed by a `separate project
   <https://github.com/dyp-cpp/cpp-draft/tree/xml>`_.
#. XML to HTML5 conversion. Peformed by this project.


-----------------------
Aims of this conversion
-----------------------

#. Reproduce the document structure and especially the names
   and numbers of the sections of the original LaTeX sources
   or the PDF output of those, respectively.
#. Showcase the LaTeX to XML conversion. Demonstrate what
   can be done easily with the XML version.
#. A linkable, easily accessible draft. It shall be possible
   to refer to this document and specific parts of it easily.
#. Readability. With and without stylesheets, the resulting
   HTML5 should be as readable as possible.
#. Produce valid HTML5.


--------------------
About
--------------------

The XML to HTML5 conversion depends of course on the structure
of the XML document. Since this structure is not stable, the
LaTeX to XML conversion has been included as a submodule, to
link the current XML to HTML5 conversion to the XML conversion
version.

The LaTeX to XML conversion is a `distinct project
<https://github.com/dyp-cpp/cpp-draft/tree/xml>`_.

This project uses a single XSL transformation split into several
files. Additionally, a CSS file is provided that is linked in
the resulting HTML5.
The XSLT is to be applied to the cleaned XML output of the
LaTeX to XML conversion toolchain.


Known restrictions and flaws
============================

The transformation only supports the current output of the LaTeX
to XML transformation. For example, no code is included to
transform the library part yet.

A feature to detect broken references has been deactivated due
to performance reasons.
Originally, all references to parts not contained within the XML
should be formatted differently; but the check required a huge
amount of time using libxml's ``xsltproc``.


Copyright
=========

Do whatever you want.
Also see the ``UNLICENSE`` file.


Author
======

Responsible for this hacky conversion is::

   dyp <dyp-cpp@gmx.net>

Please send me encrypted and signed e-mails::

   http://pgp.mit.edu/pks/lookup?op=get&search=0xC266E5BC26C0704A
