# Installation Guide 🚀

## Quick Start (5 minutes)

```bash
# 1. Clone the repository
git clone https://github.com/AmosTheBuilder/submodel-system.git
cd submodel-system

# 2. Run the automated setup
./setup.sh

# 3. Test your installation
python3 submodel_manager.py --query "What is machine learning?" --model general

# 4. Check performance stats
python3 submodel_manager.py --stats
```

**That's it!** You now have intelligent submodel caching working.

## Detailed Installation

### Prerequisites

- **Python 3.7+** - Check with `python3 --version`
- **Ollama** - For running local AI models
- **Git** - For cloning the repository

### Step 1: Install Ollama

```bash
# macOS/Linux
curl -fsSL https://ollama.com/install.sh | sh

# Or download from https://ollama.com/download
```

### Step 2: Download Recommended Models

```bash
# Small fast model for general queries
ollama pull llama3.2:3b

# Medium model for coding tasks
ollama pull codellama:7b

# Larger model for creative work
ollama pull llama3.1:8b
```

### Step 3: Install the Submodel System

```bash
# Clone repository
git clone https://github.com/AmosTheBuilder/submodel-system.git
cd submodel-system

# Make scripts executable
chmod +x setup.sh
chmod +x submodel_manager.py

# Run setup (creates config files and directories)
./setup.sh
```

### Step 4: Verify Installation

```bash
# Test basic functionality
python3 submodel_manager.py --query "Test query" --model general

# Check if everything works
python3 submodel_manager.py --stats
```

## Configuration Options

### Backend Selection

**SQLite (Default)** - Best for most agents:
```json
{
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/cache.db"
  }
}
```

**Redis** - For high-performance scenarios:
```json
{
  "cache": {
    "backend": "redis",
    "host": "localhost",
    "port": 6379,
    "db": 0
  }
}
```

### Model Configuration

**Basic Setup** (Recommended for beginners):
```json
{
  "default_model": "general",
  "models": {
    "general": {
      "name": "llama3.2:3b",
      "description": "Fast general-purpose reasoning",
      "cache_ttl": 3600
    }
  }
}
```

**Advanced Setup** (For power users):
```json
{
  "default_model": "general",
  "models": {
    "general": {
      "name": "llama3.2:3b",
      "description": "Fast general-purpose reasoning",
      "cache_ttl": 3600
    },
    "coding": {
      "name": "codellama:7b",
      "description": "Specialized for code generation",
      "cache_ttl": 1800
    },
    "creative": {
      "name": "llama3.1:8b",
      "description": "Enhanced creative writing",
      "cache_ttl": 7200
    },
    "analysis": {
      "name": "llama3.1:13b",
      "description": "Deep analysis and reasoning",
      "cache_ttl": 3600
    }
  }
}
```

## Troubleshooting

### "Ollama not found"
```bash
# Start Ollama service
ollama serve

# Check if running
ollama list
```

### "Model not found"
```bash
# Download the model
ollama pull llama3.2:3b

# Verify installation
ollama list
```

### "Permission denied"
```bash
# Make scripts executable
chmod +x setup.sh
chmod +x submodel_manager.py
```

### "Cache miss rate too high"
- Increase TTL values in config
- Warm cache with frequent queries
- Check if models are responding correctly

## Performance Tuning

### For High-Traffic Agents
- Use Redis backend instead of SQLite
- Increase cache TTL for stable content
- Pre-warm cache with common queries
- Monitor hit rates and adjust accordingly

### For Resource-Constrained Systems
- Use smaller models (3B parameters)
- Reduce cache TTL to save disk space
- Use SQLite backend (lighter than Redis)
- Clean up old cache entries regularly

## Next Steps

1. **Read the SKILL.md** for complete documentation
2. **Check HEARTBEAT.md** for integration with your agent
3. **Experiment with different models** to find what works for you
4. **Share your experience** with the community!

**Need help?** Post in the repository issues or reach out to the community! 🦞