/* eslint-disable class-methods-use-this */

import { Mark } from 'tiptap';
import { toggleMark, markInputRule } from 'tiptap-commands';
import _ from 'underscore';

const tags = ['sup', 'sub', 'kbd', 'q', 'samp', 'var', 'abbr'];

// Transforms generated HTML back to GFM for Banzai::Filter::MarkdownFilter
export default class InlineHTML extends Mark {
  get name() {
    return 'inline_html';
  }

  get schema() {
    return {
      excludes: '',
      attrs: {
        tag: {},
        title: { default: null },
      },
      parseDOM: [
        {
          tag: tags.join(', '),
          getAttrs: el => ({ tag: el.nodeName.toLowerCase() }),
        },
        {
          tag: 'abbr',
          priority: 51,
          getAttrs: el => ({ tag: 'abbr', title: el.getAttribute('title') }),
        },
      ],
      toDOM: node => [node.attrs.tag, { title: node.attrs.title }, 0],
    };
  }

  get toMarkdown() {
    return {
      mixable: true,
      open(state, mark) {
        return `<${mark.attrs.tag}${
          mark.attrs.title ? ` title="${state.esc(_.escape(mark.attrs.title))}"` : ''
        }>`;
      },
      close(state, mark) {
        return `</${mark.attrs.tag}>`;
      },
    };
  }

  commands({ type }) {
    return () => toggleMark(type);
  }

  inputRules({ type }) {
    return tags.map(tag =>
      markInputRule(new RegExp(`(?:\\<${tag}\\>)([^\\<]+)(?:\\<\\/${tag}\\>)$`), type, { tag }),
    );
  }
}
