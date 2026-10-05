# renku-github-jupyter

Renku project: [opendatazurich/github-jupyter](https://renkulab.io/p/opendatazurich/github-jupyter)

Renku launcher that downloads a Jupyter notebook from GitHub and opens it automatically
at session start.

## What does this project do?

The Renku session launcher for this repository starts JupyterLab. If you pass the
`GITHUB_FILEPATH` parameter in the Renku URL, the corresponding notebook is downloaded from
GitHub and opened automatically when the session starts.

If the parameter is not set (or set to `NONE`), JupyterLab starts normally and offers the
bundled example notebook `hello_world.ipynb` for selection.

The download uses GitHub's raw content service (`https://raw.githubusercontent.com/…`). Only
publicly published notebooks can be downloaded; there is no token support for private
repositories.

## URL parameter `GITHUB_FILEPATH`

The value is the path to a notebook on GitHub, **without** scheme and host. Two spellings are
accepted:

| Variant       | Example                                                                                                   |
| ------------- | --------------------------------------------------------------------------------------------------------- |
| View path (with `/blob/`)     | `opendatazurich/opendatazurich.github.io/blob/master/zt-api/ZuerichTourismusAPI-Beispiele.ipynb` |
| Raw path (without `/blob/`)   | `opendatazurich/opendatazurich.github.io/master/zt-api/ZuerichTourismusAPI-Beispiele.ipynb`           |

Both variants produce the same result; `/blob/` is stripped automatically. From the raw path the
download link `https://raw.githubusercontent.com/<owner>/<repo>/<branch>/<path>` is built.

### Full Renku URL

```
https://renkulab.io/p/opendatazurich/github-jupyter/sessions/01M3PPQJDDQZ4YD7CD7DZ5S5ER/start?GITHUB_FILEPATH=<owner>/<repo>/<branch>/<path>.ipynb
```

> The value is URL-encoded in the path (e.g. spaces become `%20`). Special characters are
> therefore possible but not tested.

## Examples

Open a real notebook (raw path):

```
https://renkulab.io/p/opendatazurich/github-jupyter/sessions/01M3PPQJDDQZ4YD7CD7DZ5S5ER/start?GITHUB_FILEPATH=opendatazurich/opendatazurich.github.io/master/zt-api/ZuerichTourismusAPI-Beispiele.ipynb
```

The same notebook via the view path (with `/blob/`):

```
https://renkulab.io/p/opendatazurich/github-jupyter/sessions/01M3PPQJDDQZ4YD7CD7DZ5S5ER/start?GITHUB_FILEPATH=opendatazurich/opendatazurich.github.io/blob/master/zt-api/ZuerichTourismusAPI-Beispiele.ipynb
```

Default (no notebook, JupyterLab without a specific file):

```
https://renkulab.io/p/opendatazurich/github-jupyter/sessions/01M3PPQJDDQZ4YD7CD7DZ5S5ER/start?GITHUB_FILEPATH=NONE
```

## Error behaviour

If the path does not point to an existing notebook (404, non-existent branch, non-public), the
download fails silently. The session keeps running in default mode (JupyterLab without a
specific notebook) instead of aborting.
