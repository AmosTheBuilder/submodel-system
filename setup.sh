#!/bin/bash
# Submodel System Setup Script
# Sets up intelligent AI model management with caching for agents

set -e

echo "🧠 Setting up Submodel System..."

# Create directory structure
SUBMODEL_DIR="$HOME/.config/submodels"
echo "📁 Creating directory structure at $SUBMODEL_DIR"
mkdir -p "$SUBMODEL_DIR"
mkdir -p "$SUBMODEL_DIR/examples"
mkdir -p "$SUBMODEL_DIR/scripts"

# Check for Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed"
    exit 1
fi

# Check for pip
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is required but not installed"
    exit 1
fi

# Install required Python packages
echo "📦 Installing Python dependencies..."
pip3 install --user redis sqlite3 hashlib dataclasses pathlib

# Check for Ollama
if ! command -v ollama &> /dev/null; then
    echo "🔧 Ollama not found. Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

# Test Ollama connection
echo "🚀 Testing Ollama connection..."
if ! ollama list &> /dev/null; then
    echo "⚠️  Ollama service not running. Starting Ollama..."
    ollama serve &
    sleep 5
fi

# Download default models (optional - can be done later)
echo "📥 Setting up default models..."
cat > "$SUBMODEL_DIR/download-models.sh" << 'EOF'
#!/bin/bash
# Download recommended models for submodel system

echo "Downloading recommended models..."

# Small fast model for general queries
ollama pull llama3.2:3b

# Medium model for balanced tasks  
ollama pull codellama:7b

# Larger model for quality work
ollama pull llama3.1:8b

echo "✅ Models downloaded! You can now use the submodel system."
EOF

chmod +x "$SUBMODEL_DIR/download-models.sh"

# Create default configuration
echo "⚙️  Creating default configuration..."
cat > "$SUBMODEL_DIR/config.json" << 'EOF'
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
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/cache.db"
  }
}
EOF

# Create example configurations
echo "📋 Creating example configurations..."

# Email assistant example
cat > "$SUBMODEL_DIR/examples/email-assistant.json" << 'EOF'
{
  "default_model": "classify",
  "models": {
    "classify": {
      "name": "llama3.2:3b",
      "description": "Classify email intent and urgency",
      "cache_ttl": 1800
    },
    "draft": {
      "name": "llama3.1:8b",
      "description": "Draft professional email responses",
      "cache_ttl": 3600
    },
    "polish": {
      "name": "llama3.1:8b",
      "description": "Refine and polish final drafts",
      "cache_ttl": 7200
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/email-cache.db"
  }
}
EOF

# Code review example
cat > "$SUBMODEL_DIR/examples/code-review.json" << 'EOF'
{
  "default_model": "analyze",
  "models": {
    "analyze": {
      "name": "codellama:7b",
      "description": "Analyze code structure and patterns",
      "cache_ttl": 3600
    },
    "suggest": {
      "name": "codellama:13b",
      "description": "Generate improvement suggestions",
      "cache_ttl": 1800
    },
    "explain": {
      "name": "llama3.1:8b",
      "description": "Explain complex concepts clearly",
      "cache_ttl": 7200
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/code-cache.db"
  }
}
EOF

# Create convenience scripts
echo "📝 Creating convenience scripts..."

cat > "$SUBMODEL_DIR/scripts/quick-test.py" << 'EOF'
#!/usr/bin/env python3
# Quick test of submodel system

import sys
sys.path.append('~/.config/submodels')

from submodel_manager import SubmodelManager

def main():
    print("🧠 Testing Submodel System...")
    
    manager = SubmodelManager()
    
    # Test general model
    print("\n📝 Testing general model...")
    response = manager.query("What is the capital of France?", "general")
    print(f"Response: {response[:100]}...")
    
    # Show stats
    stats = manager.get_stats()
    print(f"\n📊 Cache hit rate: {stats['hit_rate']}")
    
    # Test same query again (should hit cache)
    print("\n🎯 Testing cache hit...")
    response2 = manager.query("What is the capital of France?", "general")
    stats2 = manager.get_stats()
    print(f"New hit rate: {stats2['hit_rate']}")

if __name__ == "__main__":
    main()
EOF

chmod +x "$SUBMODEL_DIR/scripts/quick-test.py"

# Create main CLI wrapper
cat > "$SUBMODEL_DIR/submodel" << 'EOF'
#!/usr/bin/env python3
import sys
import os
sys.path.append(os.path.expanduser('~/.config/submodels'))

from submodel_manager import main

if __name__ == "__main__":
    sys.exit(main())
EOF

chmod +x "$SUBMODEL_DIR/submodel"

# Create symlink for global access
ln -sf "$SUBMODEL_DIR/submodel" "$HOME/.local/bin/submodel" 2>/dev/null || true

echo ""
echo "✅ Submodel System setup complete!"
echo ""
echo "📚 Next steps:"
echo "1. Download models: $SUBMODEL_DIR/download-models.sh"
echo "2. Test the system: $SUBMODEL_DIR/scripts/quick-test.py"
echo "3. Use CLI: submodel --query 'Your question here' --model general"
echo "4. Integrate into your agent code"
echo ""
echo "📖 Documentation:"
echo "- Config file: $SUBMODEL_DIR/config.json"
echo "- Examples: $SUBMODEL_DIR/examples/"
echo "- Python API: Import SubmodelManager from ~/.config/submodels/"
echo ""
echo "🦞 Ready to speed up your AI responses with intelligent caching!"
EOF

chmod +x /home/vim/.openclaw/workspace/submodel-system/setup.sh

echo "✅ Submodel System skill created!"
echo ""
echo "📦 To install:"
echo "cd /home/vim/.openclaw/workspace/submodel-system"
echo "./setup.sh"
echo ""
echo "🧠 This will give other agents the same submodel caching capabilities I use!"