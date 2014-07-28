=====================================================================================
Converting the C++ Standard Draft Sources from XML to the C++ HTML document framework
=====================================================================================

This is a very early technological preview of a conversion
of the C++ Standard Draft Sources to the `C++ HTML document
framework <https://github.com/cplusplus/html-doc-framework>`_
(abbreviated to C++HDF within this document).

The conversion is performed in two steps from the original
LaTeX sources:

#. LaTeX to XML conversion. Performed by a `separate project
   <https://github.com/dyp-cpp/cpp-draft/tree/xml>`_.
#. XML to C++HDF conversion. Peformed by this project.


-----------------------
Aims of this conversion
-----------------------

This is a feasibility test as well as a "technological" preview.
Its current aim is to demonstrate that it is possible to convert
the C++ Standard Draft Sources to the C++HDF to some extent.

Possible near-future aims include:

#. Express as much as possible of the intent and structure of
   the LaTeX sources in the C++HDF.
#. Show the extent to which such a conversion is possible.
#. Provide ideas for extensions of the C++HDF.


--------------------
About
--------------------

This conversion is derived from the `XML to HTML5 conversion
<https://github.com/dyp-cpp/draft2html5>`_.

The LaTeX to XML conversion is a `distinct project
<https://github.com/dyp-cpp/cpp-draft/tree/xml>`_.

This project uses a single XSL transformation split into several
files.
The XSLT is to be applied to the cleaned XML output of the
LaTeX to XML conversion toolchain.

To view the resulting C++HDF document, please install the
C++HDF in the root directory of your copy of this repository
as described in `the html-doc-framework readme
<https://github.com/cplusplus/html-doc-framework>`_,
and use an HTTP server to serve it to the browser.


Known restrictions and flaws
============================

The transformation only supports the current output of the LaTeX
to XML transformation. For example, no code is included to
transform the library part yet.


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
