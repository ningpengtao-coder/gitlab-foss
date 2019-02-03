/* eslint-disable class-methods-use-this */

import { HorizontalRule as BaseHorizontalRule } from 'tiptap-extensions';
import { InputRule } from 'prosemirror-inputrules';
import { defaultMarkdownSerializer } from 'prosemirror-markdown';

// Transforms generated HTML back to GFM for Banzai::Filter::MarkdownFilter
export default class HorizontalRule extends BaseHorizontalRule {
  toMarkdown(state, node) {
    defaultMarkdownSerializer.nodes.horizontal_rule(state, node);
  }

  inputRules({ type }) {
    return [
      new InputRule(/^---$/, (state, match, start, end) =>
        state.tr.delete(start, end).insert(start - 1, type.create()),
      ),
    ];
  }
}
