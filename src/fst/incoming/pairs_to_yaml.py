#!/usr/bin/env python3
# Convert foma 'pairs' output to well-formatted and consistently named
# YAML files.

import argparse
import sys
import unidecode

header = \
"""Config:
  hfst:
    Gen: ../../../src/generator-gt-norm.hfst
    Morph: ../../../src/analyser-gt-norm.hfst
  xerox:
    Gen: ../../../src/generator-gt-norm.xfst
    Morph: ../../../src/analyser-gt-norm.xfst
    App: lookup"""

# Order of subjects.
intransitive = [ 'SbjSg1', 'SbjSg2', 'SbjSg3', \
                 'SbjPl1', 'SbjPl1+Distr', 'SbjPl2', 'SbjPl2+Distr', \
                 'SbjPl3', 'SbjPl3+Distr', 'SbjSg4', 'SbjSg4+Distr' ]

def format_lemma(lemma):
    return unidecode.unidecode(lemma).replace('[', '_').replace(']', '').replace(' ', '_').replace("'", '')

def to_yaml(analysis_to_forms, tama = '0', to_stdout = False):
    # Grab a random analysis, ...
    example_analysis = list(analysis_to_forms.keys())[0].strip()
    base = example_analysis[:example_analysis.find("Sbj") - 1]
    (lemma, pos, argstruct, aspect) = tuple(base.split('+', 3))

    fname = None
    labels = None
    if pos == 'V':
        # e.g., "V-INTR-IPFV-0-itsiy.yaml"
        fname = "V-"
        if argstruct == 'I':
            fname += "INTR-"
            labels = intransitive
        else:
            raise('Argument structure types other than intransitive not '\
                  'implemented yet')

        fname += "%s-%s-%s.yaml" % \
            (aspect.replace("+", "_").upper(), tama, format_lemma(lemma))
    else:
        raise('Parts of speech other than verbs not implemented yet')

    output = sys.stdout
    if not to_stdout:
        output = open(fname, 'w')

    # Assuming only verbs for now; otherwise parse 'example_analysis' and
    # produce different output based on different POS.
    output.write(header)
    output.write("\n\n")
    output.write("Tests:\n")
    output.write("  Verb - %s :\n" % lemma)
    
    # This is a nasty hack, but by iterating over these analysis strings,
    # we can find out their maximum string length, which allows us to
    # vertically align the generated forms in the pretty-printed yaml output.
    max_analysis_width = -1
    for label in labels:
        max_analysis_width = max(max_analysis_width, \
            len("%s+%s:" % (base, label)))

    for label in labels:
        analysis = "%s+%s" % (base, label)
        forms = analysis_to_forms.pop(analysis)
        analysis += ":"
        if len(forms) > 1:
            output.write('    %s [%s]\n' % \
                (analysis.ljust(max_analysis_width), ', '.join(forms)))
        else:
            output.write('    %s %s\n' % \
                (analysis.ljust(max_analysis_width), forms[0]))

    # Confirm that we've printed out all of the forms and analyses that we
    # were provided with.
    if len(analysis_to_forms) > 0:
        raise("Additional forms not specified for this argument structure: "\
            "%s" % analysis_to_forms)


parser = argparse.ArgumentParser(description = \
    'Convert foma pairs output into properly-named yaml files')
parser.add_argument('-t', '--test', action = 'store_true', \
    help = 'only write yaml to stdout (without saving in a separate file)')
parser.add_argument('files', nargs='+', \
    help = 'pairs output from foma')
args = parser.parse_args()

for fn in args.files:
    with open(fn) as f:
        # Read the TAMA choice out of the pairs file name (should be the
        # last hyphen-separated element before the file extension, e.g.,
        # "didus_crawl_pairs_output-0.txt"). Note that yi-yi and yi-a
        # perfectives should be named "yi_yi" and "yi_a" in pairs file
        # names.
        tama = fn[fn.rfind('-') + 1:fn.rfind('.txt')]

        analysis_to_forms = {}
        for ln in f:
            (analysis, form) = ln.strip().split('\t')
            if not analysis in analysis_to_forms:
                analysis_to_forms[analysis] = [form]
            else:
                forms = analysis_to_forms[analysis]
                if not form in forms:
                    forms.append(form)

        to_yaml(analysis_to_forms, tama, to_stdout = args.test)
