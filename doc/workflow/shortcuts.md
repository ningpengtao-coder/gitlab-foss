---
type: reference
---

# GitLab keyboard shortcuts

GitLab has many useful keyboard shortcuts to make it easier to access different features.
You can see the quick reference sheet within GitLab itself with <kbd>shift</kbd> + <kbd>?</kbd>.

In general, you don't anything selected for these to work (unless otherwise noted),
but certain shortcuts are related to specific pages in GitLab, so you must be on that
page for them to work, as noted in each section below.

## Global Shortcuts

These shortcuts are available in most areas of GitLab.

| Keyboard Shortcut               | Description |
| ------------------------------- | ----------- |
| <kbd>?</kbd>                    | Show/hide shortcut reference sheet. |
| <kbd>Shift</kbd> + <kbd>p</kbd> | Go to your Projects page. |
| <kbd>Shift</kbd> + <kbd>a</kbd> | Go to your Activity page. |
| <kbd>Shift</kbd> + <kbd>l</kbd> | Go to your Milestones page. |
| <kbd>Shift</kbd> + <kbd>s</kbd> | Go to your Snippets page. |
| <kbd>Shift</kbd> + <kbd>i</kbd> | Go to your Issues page. |
| <kbd>Shift</kbd> + <kbd>m</kbd> | Go to your Merge requests page .|
| <kbd>Shift</kbd> + <kbd>t</kbd> | Go to your To-Do List page. |
| <kbd>p</kbd> + <kbd>b</kbd>     | Show/hide the Performance Bar. |
| <kbd>s</kbd>                    | Put cursor in the issues/merge requests search. |
| <kbd>↑</kbd>                    | Edit your last comment. You must be in a blank text field below a thread, and you must already have at least one comment in the thread. |
| <kbd>Cmd</kbd>/<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>p</kbd> | Toggle markdown preview, when editing text in a textfield that has **Write** and **Preview** tabs at the top. |

## Project

These shortcuts are available from any page within a project. You must type them
relatively quickly to work, and they will take you to another page in the project.

| Keyboard Shortcut           | Description |
| --------------------------- | ----------- |
| <kbd>g</kbd> + <kbd>p</kbd> | Go to the project home page (**Project** > **Details**). |
| <kbd>g</kbd> + <kbd>v</kbd> | Go to the project activity feed (**Project** > **Activity**). |
| <kbd>g</kbd> + <kbd>f</kbd> | Go to the [project files](#project-files) list (**Repository** > **Files**). |
| <kbd>t</kbd>                | Go to the [find project file](#find-project-files) page. (**Repository** > **Files**, click **Find Files**) |
| <kbd>g</kbd> + <kbd>c</kbd> | Go to the project commits list (**Repository** > **Commits**). |
| <kbd>g</kbd> + <kbd>n</kbd> | Go to the [repository graph](#repository-graph) page (**Repository** > **Graph**). |
| <kbd>g</kbd> + <kbd>d</kbd> | Go to repository charts (**Repository** > **Charts**). |
| <kbd>g</kbd> + <kbd>i</kbd> | Go to the project issues list (**Issues** > **List**). |
| <kbd>i</kbd>                | Go to the New Issue page (**Issues**, click **New Issue** ) |
| <kbd>g</kbd> + <kbd>b</kbd> | Go to the project issue boards list (**Issues** > **Boards**). |
| <kbd>g</kbd> + <kbd>m</kbd> | Go to the project merge requests list (**Merge Requests**). |
| <kbd>g</kbd> + <kbd>j</kbd> | Go to the CI/CD jobs list (**CI/CD** > **Jobs**). |
| <kbd>g</kbd> + <kbd>e</kbd> | Go to the project environments (**Operations** > **Environments**). |
| <kbd>g</kbd> + <kbd>k</kbd> | Go to the project kubernetes cluster integration page (**Operations** > **Kubernetes**). Note that you must have at least [`maintainer` permissions](../user/permissions.md) to access this page. |
| <kbd>g</kbd> + <kbd>s</kbd> | Go to the project snippets list (**Snippets**). |
| <kbd>g</kbd> + <kbd>w</kbd> | Go to the project wiki (**Wiki**), if enabled. |

### Project Files

These shortcuts are available when browsing the files in a project (navigate to
**Repository** > **Files**):

| Keyboard Shortcut | Description |
| ----------------- | ----------- |
| <kbd>↑</kbd>      | Move selection up |
| <kbd>↓</kbd>      | Move selection down |
| <kbd>enter</kbd>  | Open selection |

#### Find Project Files

These shortcuts are available when searching for files (navigate to **Repository** > **Files**
then click on **Find File**):

| Keyboard Shortcut | Description |
| ----------------- | ----------- |
| <kbd>↑</kbd>      | Move selection up |
| <kbd>↓</kbd>      | Move selection down |
| <kbd>enter</kbd>  | Open selection |
| <kbd>esc</kbd>    | Go back to file list screen |

### Repository Graph

These shortcuts are available when viewing the project [repository graph](../user/project/repository/index.md#repository-graph)
page (navigate to **Repository** > **Graph**):

| Keyboard Shortcut | Description |
| ----------------- | ----------- |
| <kbd>←</kbd> or <kbd>h</kbd> | Scroll left |
| <kbd>→</kbd> or <kbd>l</kbd> | Scroll right |
| <kbd>↑</kbd> or <kbd>k</kbd> | Scroll up |
| <kbd>↓</kbd> or <kbd>j</kbd> | Scroll down |
| <kbd>Shift</kbd> + <kbd>↑</kbd> or <kbd>Shift</kbd> + <kbd>k</kbd> | Scroll to top |
| <kbd>Shift</kbd> + <kbd>↓</kbd> or <kbd>Shift</kbd> + <kbd>j</kbd> | Scroll to bottom |

### Issues and Merge Requests

These shortcuts are available when viewing issues and merge requests.

| Keyboard Shortcut | Description |
| ----------------- | ----------- |
| <kbd>a</kbd>      | Change assignee. |
| <kbd>m</kbd>      | Change milestone. |
| <kbd>r</kbd>      | Start writing a comment. If any text is selected, it will be quoted in the comment. Can't be used to reply within a thread. |
| <kbd>e</kbd>      | Edit description. |
| <kbd>l</kbd>      | Change label. |
| <kbd>]</kbd> or <kbd>j</kbd> | Move to next file. |
| <kbd>[</kbd> or <kbd>k</kbd> | Move to previous file. |

## Epics **(ULTIMATE)**

These shortcuts are available when viewing [Epics](../user/group/epics/index.md):

| Keyboard Shortcut | Description |
| ----------------- | ----------- |
| <kbd>r</kbd>      | Start writing a comment. If any text is selected, it will be quoted in the comment. Can't be used to reply within a thread. |
| <kbd>e</kbd>      | Edit description |
| <kbd>l</kbd>      | Change label |

## Wiki pages

This shortcut is available when viewing a [wiki page](../user/project/wiki/index.md):

| Keyboard Shortcut | Description |
| ----------------- | ----------- |
| <kbd>e</kbd>      | Edit wiki page |

## Web IDE

These shortcuts are available when editing a file with the [Web IDE](../user/project/web_ide/index.md):

| Keyboard Shortcut | Description |
| ----------------- | ----------- |
| <kbd>Cmd</kbd>/<kbd>Ctrl</kbd> + <kbd>p</kbd> | Search for, and then open another file for editing |
| <kbd>Cmd</kbd>/<kbd>Ctrl</kbd> + <kbd>Enter</kbd> | Commit (when editing the commit message) |
