# MEMORY.md - Long-Term Memory

## 使用习惯

- **语言偏好：** 回答问题必需用中文（2026-02-27 记录）

## Skill Development Convention (Added 2026-02-26)

**All new skills must be saved to `/root/.openclaw/workspace/skills/` folder.**

This is the single source of truth for all skills. The structure should be:

```
skills/
├── skill-name/
│   ├── SKILL.md           # Main documentation
│   ├── scripts/           # Executable scripts
│   └── references/        # Test and reference materials
└── skill-name.skill       # Packaged skill file
```

When creating a new skill:
1. Create source files in `skills/skill-name/`
2. Update `TOOLS.md` and `MEMORY.md` with relevant paths

## Skill Package Location

All skill packages are stored in: `/root/.openclaw/workspace/skills/`

- `agent-browser`
- `self-imporving`

## Skill Source Files

Each skill's source files (SKILL.md, scripts/, references/) are also stored in `/root/.openclaw/workspace/skills/` for reference and editing.