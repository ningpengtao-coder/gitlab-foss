/* eslint-disable import/no-commonjs */
/* eslint-disable vanilla-i18n/detect-non-i18n-string */
const adapt = require('vue-jscodeshift-adapter');

const extFunc = '__';
const pkg = `~/locale`;

const isExternalizationCall = exp => exp.value.callee.name === extFunc;
const hasExternalizationCall = ({ root, j }) =>
  !!root.find(j.CallExpression).filter(isExternalizationCall);

const externalizationImportFilter = {
  imported: {
    name: extFunc,
  },
};

const hasExternalizationImport = ({ root, j }) =>
  root.find(j.ImportSpecifier, externalizationImportFilter).size();

function importExternalizationFunction({ root, j }) {
  const i = j.importDeclaration([j.importSpecifier(j.identifier(extFunc))], j.literal(pkg));
  const oldBody = root.get().value.program.body;
  root.get().value.program.body = [i, ...oldBody];
  return root;
}

function FixExternalizeImports(file, api) {
  const j = api.jscodeshift;
  const initRoot = j(file.source);

  const root =
    hasExternalizationCall({ root: initRoot, j }) &&
    !hasExternalizationImport({ root: initRoot, j })
      ? importExternalizationFunction({ root: initRoot, j })
      : initRoot;

  return root.toSource();
}

module.exports = adapt(FixExternalizeImports);
