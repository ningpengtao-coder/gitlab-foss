/* eslint-disable class-methods-use-this */

import { Strike as BaseStrike } from 'tiptap-extensions';
import { markInputRule } from 'tiptap-commands';

// Transforms generated HTML back to GFM for Banzai::Filter::MarkdownFilter
export default class Strike extends BaseStrike {
  get toMarkdown() {
    return {
      open: '~~',
      close: '~~',
      mixable: true,
      expelEnclosingWhitespace: true,
    };
  }

  inputRules({ type }) {
    return [markInputRule(/~~([^~]+)~~$/, type)];
  }
}
