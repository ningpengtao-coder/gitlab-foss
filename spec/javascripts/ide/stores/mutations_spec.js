import mutations from '~/ide/stores/mutations';
import state from '~/ide/stores/state';
import { file } from '../helpers';

describe('Multi-file store mutations', () => {
  let localState;
  let entry;

  beforeEach(() => {
    localState = state();
    entry = file();

    localState.entries[entry.path] = entry;
  });

  describe('SET_INITIAL_DATA', () => {
    it('sets all initial data', () => {
      mutations.SET_INITIAL_DATA(localState, {
        test: 'test',
      });

      expect(localState.test).toBe('test');
    });
  });

  describe('TOGGLE_LOADING', () => {
    it('toggles loading of entry', () => {
      mutations.TOGGLE_LOADING(localState, { entry });

      expect(entry.loading).toBeTruthy();

      mutations.TOGGLE_LOADING(localState, { entry });

      expect(entry.loading).toBeFalsy();
    });

    it('toggles loading of entry and sets specific value', () => {
      mutations.TOGGLE_LOADING(localState, { entry });

      expect(entry.loading).toBeTruthy();

      mutations.TOGGLE_LOADING(localState, { entry, forceValue: true });

      expect(entry.loading).toBeTruthy();
    });
  });

  describe('SET_LEFT_PANEL_COLLAPSED', () => {
    it('sets left panel collapsed', () => {
      mutations.SET_LEFT_PANEL_COLLAPSED(localState, true);

      expect(localState.leftPanelCollapsed).toBeTruthy();

      mutations.SET_LEFT_PANEL_COLLAPSED(localState, false);

      expect(localState.leftPanelCollapsed).toBeFalsy();
    });
  });

  describe('SET_RIGHT_PANEL_COLLAPSED', () => {
    it('sets right panel collapsed', () => {
      mutations.SET_RIGHT_PANEL_COLLAPSED(localState, true);

      expect(localState.rightPanelCollapsed).toBeTruthy();

      mutations.SET_RIGHT_PANEL_COLLAPSED(localState, false);

      expect(localState.rightPanelCollapsed).toBeFalsy();
    });
  });

  describe('CLEAR_STAGED_CHANGES', () => {
    it('clears stagedFiles array', () => {
      localState.stagedFiles.push('a');

      mutations.CLEAR_STAGED_CHANGES(localState);

      expect(localState.stagedFiles.length).toBe(0);
    });
  });

  describe('CLEAR_REPLACED_FILES', () => {
    it('clears replacedFiles array', () => {
      localState.replacedFiles.push('a');

      mutations.CLEAR_REPLACED_FILES(localState);

      expect(localState.replacedFiles.length).toBe(0);
    });
  });

  describe('UPDATE_VIEWER', () => {
    it('sets viewer state', () => {
      mutations.UPDATE_VIEWER(localState, 'diff');

      expect(localState.viewer).toBe('diff');
    });
  });

  describe('UPDATE_ACTIVITY_BAR_VIEW', () => {
    it('updates currentActivityBar', () => {
      mutations.UPDATE_ACTIVITY_BAR_VIEW(localState, 'test');

      expect(localState.currentActivityView).toBe('test');
    });
  });

  describe('SET_EMPTY_STATE_SVGS', () => {
    it('updates empty state SVGs', () => {
      mutations.SET_EMPTY_STATE_SVGS(localState, {
        emptyStateSvgPath: 'emptyState',
        noChangesStateSvgPath: 'noChanges',
        committedStateSvgPath: 'commited',
      });

      expect(localState.emptyStateSvgPath).toBe('emptyState');
      expect(localState.noChangesStateSvgPath).toBe('noChanges');
      expect(localState.committedStateSvgPath).toBe('commited');
    });
  });

  describe('CREATE_TMP_ENTRY', () => {
    beforeEach(() => {
      localState.currentProjectId = 'gitlab-ce';
      localState.currentBranchId = 'master';
      localState.trees['gitlab-ce/master'] = {
        tree: [],
      };
    });

    it('creates temp entry in the tree', () => {
      const tmpFile = file('test');
      mutations.CREATE_TMP_ENTRY(localState, {
        data: {
          entries: {
            test: {
              ...tmpFile,
              tempFile: true,
              changed: true,
            },
          },
          treeList: [tmpFile],
        },
        projectId: 'gitlab-ce',
        branchId: 'master',
      });

      expect(localState.trees['gitlab-ce/master'].tree.length).toEqual(1);
      expect(localState.entries.test.tempFile).toEqual(true);
    });

    it('marks entry as replacing previous entry if the old one has been deleted', () => {
      const tmpFile = file('test');
      localState.entries.test = {
        ...tmpFile,
        deleted: true,
      };
      mutations.CREATE_TMP_ENTRY(localState, {
        data: {
          entries: {
            test: {
              ...tmpFile,
              tempFile: true,
              changed: true,
            },
          },
          treeList: [tmpFile],
        },
        projectId: 'gitlab-ce',
        branchId: 'master',
      });

      expect(localState.trees['gitlab-ce/master'].tree.length).toEqual(1);
      expect(localState.entries.test.replaces).toEqual(true);
    });
  });

  describe('UPDATE_TEMP_FLAG', () => {
    beforeEach(() => {
      localState.entries.test = {
        ...file(),
        tempFile: true,
        changed: true,
      };
    });

    it('updates tempFile flag', () => {
      mutations.UPDATE_TEMP_FLAG(localState, { path: 'test', tempFile: false });

      expect(localState.entries.test.tempFile).toBe(false);
    });

    it('updates changed flag', () => {
      mutations.UPDATE_TEMP_FLAG(localState, { path: 'test', tempFile: false });

      expect(localState.entries.test.changed).toBe(false);
    });
  });

  describe('TOGGLE_FILE_FINDER', () => {
    it('updates fileFindVisible', () => {
      mutations.TOGGLE_FILE_FINDER(localState, true);

      expect(localState.fileFindVisible).toBe(true);
    });
  });

  describe('BURST_UNUSED_SEAL', () => {
    it('updates unusedSeal', () => {
      expect(localState.unusedSeal).toBe(true);

      mutations.BURST_UNUSED_SEAL(localState);

      expect(localState.unusedSeal).toBe(false);
    });
  });

  describe('SET_ERROR_MESSAGE', () => {
    it('updates error message', () => {
      mutations.SET_ERROR_MESSAGE(localState, 'error');

      expect(localState.errorMessage).toBe('error');
    });
  });

  describe('DELETE_ENTRY', () => {
    beforeEach(() => {
      localState.currentProjectId = 'gitlab-ce';
      localState.currentBranchId = 'master';
      localState.trees['gitlab-ce/master'] = {
        tree: [],
      };
    });

    it('sets deleted flag', () => {
      localState.entries.filePath = {
        deleted: false,
      };

      mutations.DELETE_ENTRY(localState, 'filePath');

      expect(localState.entries.filePath.deleted).toBe(true);
    });

    it('removes from root tree', () => {
      localState.entries.filePath = {
        path: 'filePath',
        deleted: false,
      };
      localState.trees['gitlab-ce/master'].tree.push(localState.entries.filePath);

      mutations.DELETE_ENTRY(localState, 'filePath');

      expect(localState.trees['gitlab-ce/master'].tree).toEqual([]);
    });

    it('removes from parent tree', () => {
      localState.entries.filePath = {
        path: 'filePath',
        deleted: false,
        parentPath: 'parentPath',
      };
      localState.entries.parentPath = {
        tree: [localState.entries.filePath],
      };

      mutations.DELETE_ENTRY(localState, 'filePath');

      expect(localState.entries.parentPath.tree).toEqual([]);
    });

    it('adds to changedFiles', () => {
      localState.entries.filePath = {
        deleted: false,
        type: 'blob',
      };

      mutations.DELETE_ENTRY(localState, 'filePath');

      expect(localState.changedFiles).toEqual([localState.entries.filePath]);
    });

    it('does not add tempFile into changedFiles', () => {
      localState.entries.filePath = {
        deleted: false,
        type: 'blob',
        tempFile: true,
      };

      mutations.DELETE_ENTRY(localState, 'filePath');

      expect(localState.changedFiles).toEqual([]);
    });

    it('removes tempFile from changedFiles when deleted', () => {
      localState.entries.filePath = {
        path: 'filePath',
        deleted: false,
        type: 'blob',
        tempFile: true,
      };

      localState.changedFiles.push({ ...localState.entries.filePath });

      mutations.DELETE_ENTRY(localState, 'filePath');

      expect(localState.changedFiles).toEqual([]);
    });
  });

  describe('UPDATE_FILE_AFTER_COMMIT', () => {
    it('updates URLs if prevPath is set', () => {
      const f = {
        ...file('test'),
        prevPath: 'testing-123',
        rawPath: `${gl.TEST_HOST}/testing-123`,
        permalink: `${gl.TEST_HOST}/testing-123`,
        commitsPath: `${gl.TEST_HOST}/testing-123`,
        blamePath: `${gl.TEST_HOST}/testing-123`,
        replaces: true,
        key: 'renamed-foo-bar',
      };
      localState.entries.test = f;
      localState.changedFiles.push(f);

      mutations.UPDATE_FILE_AFTER_COMMIT(localState, { file: f, lastCommit: { commit: {} } });

      expect(f.rawPath).toBe(`${gl.TEST_HOST}/test`);
      expect(f.permalink).toBe(`${gl.TEST_HOST}/test`);
      expect(f.commitsPath).toBe(`${gl.TEST_HOST}/test`);
      expect(f.blamePath).toBe(`${gl.TEST_HOST}/test`);
      expect(f.replaces).toBe(false);
      expect(f.key).toBe('foo-bar');
      expect(f.prevId).toBeUndefined();
      expect(f.prevPath).toBeUndefined();
      expect(f.prevName).toBeUndefined();
      expect(f.prevUrl).toBeUndefined();
    });
  });

  describe('OPEN_NEW_ENTRY_MODAL', () => {
    it('sets entryModal', () => {
      localState.entries.testPath = {
        ...file(),
      };

      mutations.OPEN_NEW_ENTRY_MODAL(localState, { type: 'test', path: 'testPath' });

      expect(localState.entryModal).toEqual({
        type: 'test',
        path: 'testPath',
        entry: localState.entries.testPath,
      });
    });
  });

  describe('RENAME_ENTRY', () => {
    beforeEach(() => {
      localState.trees = {
        'gitlab-ce/master': { tree: [] },
      };
      localState.currentProjectId = 'gitlab-ce';
      localState.currentBranchId = 'master';
      localState.entries = {
        oldPath: {
          ...file('oldPath', 'oldPath', 'blob'),
        },
      };
    });

    it('updates existing entry without creating a new one', () => {
      mutations.RENAME_ENTRY(localState, {
        path: 'oldPath',
        name: 'newPath',
        entryPath: null,
        parentPath: '',
      });

      expect(localState.entries.oldPath).toBeUndefined();
      expect(localState.entries.newPath).toBeDefined();
      expect(Object.keys(localState.entries).length).toBe(1);
    });

    it('renames entry, preserving old parameters', () => {
      Object.assign(localState.entries.oldPath, {
        url: `${gl.TEST_HOST}/oldPath`,
      });
      const oldPathData = localState.entries.oldPath;

      mutations.RENAME_ENTRY(localState, {
        path: 'oldPath',
        name: 'newPath',
        entryPath: null,
        parentPath: '',
      });

      expect(localState.entries.newPath).toEqual({
        ...oldPathData,
        id: 'newPath',
        path: 'newPath',
        name: 'newPath',
        url: `${gl.TEST_HOST}/newPath`,
        key: `renamed-${oldPathData.key}`,

        prevId: 'oldPath',
        prevName: 'oldPath',
        prevPath: 'oldPath',
        prevUrl: `${gl.TEST_HOST}/oldPath`,
      });
    });

    it('properly handles files with spaces in name', () => {
      const path = 'my fancy path';
      const newPath = 'new path';
      const oldEntry = {
        ...file(path, path, 'blob'),
        url: `${gl.TEST_HOST}/${encodeURI(path)}`,
      };

      localState.entries[path] = oldEntry;

      mutations.RENAME_ENTRY(localState, {
        path,
        name: newPath,
        entryPath: null,
        parentPath: '',
      });

      expect(localState.entries[newPath]).toEqual({
        ...oldEntry,
        id: newPath,
        path: newPath,
        name: newPath,
        url: `${gl.TEST_HOST}/new%20path`,
        key: `renamed-${oldEntry.key}`,

        prevId: path,
        prevName: path,
        prevPath: path,
        prevUrl: `${gl.TEST_HOST}/my%20fancy%20path`,
      });
    });

    it('adds to parent tree', () => {
      localState.entries.oldPath.parentPath = 'parentPath';
      localState.entries.parentPath = {
        ...file(),
      };

      mutations.RENAME_ENTRY(localState, {
        path: 'oldPath',
        name: 'newPath',
        entryPath: null,
        parentPath: 'parentPath',
      });

      expect(localState.entries.parentPath.tree.length).toBe(1);
    });

    it('sorts tree after renaming an entry', () => {
      const alpha = {
        ...file('alpha', 'alpha', 'blob'),
      };
      const beta = {
        ...file('beta', 'beta', 'blob'),
      };
      const gamma = {
        ...file('gamma', 'gamma', 'blob'),
      };
      localState.entries = { alpha, beta, gamma };

      localState.trees['gitlab-ce/master'].tree = [alpha, beta, gamma];

      mutations.RENAME_ENTRY(localState, {
        path: 'alpha',
        name: 'theta',
        entryPath: null,
        parentPath: '',
      });

      expect(localState.trees['gitlab-ce/master'].tree).toEqual([
        jasmine.objectContaining({ name: 'beta' }),
        jasmine.objectContaining({ name: 'gamma' }),
        jasmine.objectContaining({
          path: 'theta',
          name: 'theta',
        }),
      ]);
    });

    it('updates openFiles with the renamed one if the original one is open', () => {
      Object.assign(localState.entries.oldPath, {
        opened: true,
        type: 'blob',
      });
      Object.assign(localState, {
        openFiles: [localState.entries.oldPath],
      });

      mutations.RENAME_ENTRY(localState, { path: 'oldPath', name: 'newPath' });

      expect(localState.openFiles.length).toBe(1);
      expect(localState.openFiles[0].path).toBe('newPath');
    });

    it('adds renamed entry to changedFiles', () => {
      mutations.RENAME_ENTRY(localState, { path: 'oldPath', name: 'newPath' });

      expect(localState.changedFiles.length).toBe(1);
      expect(localState.changedFiles[0].path).toBe('newPath');
    });

    it('updates existing changedFiles entry with the renamed one', () => {
      const key = 'renamed-oldPath';
      const changedFile = {
        ...file('newPath', 'newPath', 'blob'),
        key,
        content: 'Bar',
      };

      Object.assign(localState, {
        changedFiles: [changedFile],
      });
      Object.assign(localState.entries.oldPath, {
        key,
        content: 'Foo',
      });

      mutations.RENAME_ENTRY(localState, { path: 'oldPath', name: 'newPath' });

      expect(localState.changedFiles.length).toBe(1);
      expect(localState.changedFiles[0].path).toBe('newPath');
      expect(localState.changedFiles[0].content).toBe('Foo');
    });
  });
});
