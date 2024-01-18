#!/usr/bin/env python3
#
# Convert foma 'pairs' output to well-formatted and consistently named YAML
# test files.
#
# Usage:
#
#

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

# Order in which tags should be presented in YAML files.
intransitive = [ 'SbjSg1', 'SbjSg2', 'SbjSg3', \
                 'SbjPl1', 'SbjPl1+Distr', 'SbjPl2', 'SbjPl2+Distr', \
                 'SbjPl3', 'SbjPl3+Distr', 'SbjSg4', 'SbjSg4+Distr' ]

transitive = [ \
    # 1SG
    'SbjSg1+DObjSg2', \
    'SbjSg1+DObjSg3', \
        'SbjSg1+DObjSg3+DObjGiven', \
        'SbjSg1+DObjSg3+DObjEmphatic', \
    'SbjSg1+DObjSg4', 'SbjSg1+DObjSg4+Distr', \
    'SbjSg1+DObjPl2', 'SbjSg1+DObjPl2+Distr', \
    'SbjSg1+DObjPl3', 'SbjSg1+DObjPl3+Distr', \
        'SbjSg1+DObjPl3+DObjGiven', 'SbjSg1+DObjPl3+DObjGiven+Distr', \
    'SbjSg1+DObjRefl', \
    'SbjSg1+DObjAreal', 'SbjSg1+DObjAreal+Distr', \

    # 2SG
    'SbjSg2+DObjSg1', \
    'SbjSg2+DObjSg3', \
        'SbjSg2+DObjSg3+DObjGiven', \
        'SbjSg2+DObjSg3+DObjEmphatic', \
    'SbjSg2+DObjSg4', 'SbjSg2+DObjSg4+Distr', \
    'SbjSg2+DObjPl1', 'SbjSg2+DObjPl1+Distr', \
    'SbjSg2+DObjPl3', 'SbjSg2+DObjPl3+Distr', \
        'SbjSg2+DObjPl3+DObjGiven', 'SbjSg2+DObjPl3+DObjGiven+Distr', \
    'SbjSg2+DObjRefl', \
    'SbjSg2+DObjAreal', 'SbjSg2+DObjAreal+Distr', \

    # 3SG
    'SbjSg3+DObjSg1', \
    'SbjSg3+DObjSg2', \
    'SbjSg3+DObjSg3', \
        'SbjSg3+DObjSg3+DObjGiven', \
    'SbjSg3+DObjSg4', 'SbjSg3+DObjSg4+Distr', \
    'SbjSg3+DObjPl1', 'SbjSg3+DObjPl1+Distr', \
    'SbjSg3+DObjPl2', 'SbjSg3+DObjPl2+Distr', \
    'SbjSg3+DObjPl3', 'SbjSg3+DObjPl3+Distr', \
        'SbjSg3+DObjPl3+DObjGiven', 'SbjSg3+DObjPl3+DObjGiven+Distr', \
    'SbjSg3+DObjRefl', \
    'SbjSg3+DObjAreal', 'SbjSg3+DObjAreal+Distr', \

    # 4SG
    'SbjSg4+DObjSg1', 'SbjSg4+DObjSg1+Distr', \
    'SbjSg4+DObjSg2', 'SbjSg4+DObjSg2+Distr', \
    'SbjSg4+DObjSg3', 'SbjSg4+DObjSg3+Distr', \
        'SbjSg4+DObjSg3+DObjGiven', 'SbjSg4+DObjSg3+DObjGiven+Distr', \
        'SbjSg4+DObjSg3+DObjEmphatic', 'SbjSg4+DObjSg3+DObjEmphatic+Distr', \
    'SbjSg4+DObjSg4', 'SbjSg4+DObjSg4+Distr', \
    'SbjSg4+DObjPl1', 'SbjSg4+DObjPl1+Distr', \
    'SbjSg4+DObjPl2', 'SbjSg4+DObjPl2+Distr', \
    'SbjSg4+DObjPl3', 'SbjSg4+DObjPl3+Distr', \
        'SbjSg4+DObjPl3+DObjGiven', 'SbjSg4+DObjPl3+DObjGiven+Distr', \
    'SbjSg4+DObjRecip', 'SbjSg4+DObjRecip+Distr', \
    'SbjSg4+DObjRefl', 'SbjSg4+DObjRefl+Distr', \
    'SbjSg4+DObjAreal', 'SbjSg4+DObjAreal+Distr', \

    # 1PL
    'SbjPl1+DObjSg2', 'SbjPl1+DObjSg2+Distr', \
    'SbjPl1+DObjSg3', 'SbjPl1+DObjSg3+Distr', \
        'SbjPl1+DObjSg3+DObjGiven', 'SbjPl1+DObjSg3+DObjGiven+Distr', \
        'SbjPl1+DObjSg3+DObjEmphatic', 'SbjPl1+DObjSg3+DObjEmphatic+Distr', \
    'SbjPl1+DObjSg4', 'SbjPl1+DObjSg4+Distr', \
    'SbjPl1+DObjPl2', 'SbjPl1+DObjPl2+Distr', \
    'SbjPl1+DObjPl3', 'SbjPl1+DObjPl3+Distr', \
        'SbjPl1+DObjPl3+DObjGiven', 'SbjPl1+DObjPl3+DObjGiven+Distr', \
    'SbjPl1+DObjRecip', 'SbjPl1+DObjRecip+Distr', \
    'SbjPl1+DObjRefl', 'SbjPl1+DObjRefl+Distr', \
    'SbjPl1+DObjAreal', 'SbjPl1+DObjAreal+Distr', \

    # 2PL
    'SbjPl2+DObjSg1', 'SbjPl2+DObjSg1+Distr', \
    'SbjPl2+DObjSg3', 'SbjPl2+DObjSg3+Distr', \
        'SbjPl2+DObjSg3+DObjGiven', 'SbjPl2+DObjSg3+DObjGiven+Distr', \
        'SbjPl2+DObjSg3+DObjEmphatic', 'SbjPl2+DObjSg3+DObjEmphatic+Distr', \
    'SbjPl2+DObjSg4', 'SbjPl2+DObjSg4+Distr', \
    'SbjPl2+DObjPl1', 'SbjPl2+DObjPl1+Distr', \
    'SbjPl2+DObjPl3', 'SbjPl2+DObjPl3+Distr', \
        'SbjPl2+DObjPl3+DObjGiven', 'SbjPl2+DObjPl3+DObjGiven+Distr', \
    'SbjPl2+DObjRecip', 'SbjPl2+DObjRecip+Distr', \
    'SbjPl2+DObjRefl', 'SbjPl2+DObjRefl+Distr', \
    'SbjPl2+DObjAreal', 'SbjPl2+DObjAreal+Distr', \

    # 3PL
    'SbjPl3+DObjSg1', 'SbjPl3+DObjSg1+Distr', \
    'SbjPl3+DObjSg2', 'SbjPl3+DObjSg2+Distr', \
    'SbjPl3+DObjSg3', 'SbjPl3+DObjSg3+Distr', \
        'SbjPl3+DObjSg3+DObjGiven', 'SbjPl3+DObjSg3+DObjGiven+Distr', \
    'SbjPl3+DObjSg4', 'SbjPl3+DObjSg4+Distr', \
    'SbjPl3+DObjPl1', 'SbjPl3+DObjPl1+Distr', \
    'SbjPl3+DObjPl2', 'SbjPl3+DObjPl2+Distr', \
    'SbjPl3+DObjPl3', 'SbjPl3+DObjPl3+Distr', \
        'SbjPl3+DObjPl3+DObjGiven', 'SbjPl3+DObjPl3+DObjGiven+Distr', \
    'SbjPl3+DObjRecip', 'SbjPl3+DObjRecip+Distr', \
    'SbjPl3+DObjRefl', 'SbjPl3+DObjRefl+Distr', \
    'SbjPl3+DObjAreal', 'SbjPl3+DObjAreal+Distr' \
]


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
        elif argstruct == 'T':
            fname += "TR-"
            labels = transitive
        else:
            raise Exception('Argument structure types other than '\
                'intransitive and intransitive not implemented yet')

        fname += "%s-%s-%s_gt-norm.yaml" % \
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
