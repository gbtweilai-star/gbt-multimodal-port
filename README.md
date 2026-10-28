# multimodal_port

**One capability bit from GBT V8, packaged standalone.** No. 136 of 341,
`llm` domain (LLM).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 多模态维度 × 触手密钥 **Y 字端口**：请求在一处分叉、**一次只走一臂** ——独立臂（该维度专属密钥）/ 共享臂（共享密钥对按维度分账，须恰好成对、指纹互不相同、带 owner_ai_id 可追）；覆盖 text/vision/image/video/code 五维度，七道闸 Y0-Y6 机械把关，返回值**永不含明文**（只 key_id/掩码/指纹），没钥匙就如实报缺。status/port/catalog/redlines/selftest 为**读类直连**（port 只回密钥引用且标 readonly）；probe **真出网**探端点 ⇒ 过 external_llm 门；作用域声明挂在 cap 边界（security/policy.py::evaluate）

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-multimodal-port.git
cd gbt-multimodal-port
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_multimodal_port info                  # capability card
python -m gbt_multimodal_port spec --json           # machine-readable contract
python -m gbt_multimodal_port check --payload '{}'
python -m gbt_multimodal_port run   --payload '{}'
```

Real `info` output from this machine:

```text
multimodal_port  (llm)  v1.0.0
----------------------------------------
多模态维度 × 触手密钥 **Y 字端口**：请求在一处分叉、**一次只走一臂** ——独立臂（该维度专属密钥）/ 共享臂（共享密钥对按维度分账，须恰好成对、指纹互不相同、带 owner_ai_id 可追）；覆盖 text/vision/image/video/code 五维度，七道闸 Y0-Y6 机械把关，返回值**永不含明文**（只 key_id/掩码/指纹），没钥匙就如实报缺。status/port/catalog/redlines/selftest 为**读类直连**（port 只回密钥引用且标 readonly）；probe **真出网**探端点 ⇒ 过 external_llm 门；作用域声明挂在 cap 边界（security/policy.py::evaluate）

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : text, vision, image, video, code
```

Wire a real implementation:

```python
from gbt_multimodal_port import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（5 个）**：`text`、`vision`、`image`、`video`、`code`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `multimodal_port` |
| domain | `llm` |
| handler | `multimodal_port` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [llm/multimodal_port](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/llm/multimodal_port.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
