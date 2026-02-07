# Configuration Examples 🎯

## Quick Start Configurations

### 1. Minimal Agent (Fast & Light)
```json
{
  "default_model": "general",
  "models": {
    "general": {
      "name": "llama3.2:3b",
      "description": "Fast general-purpose reasoning",
      "cache_ttl": 1800
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/minimal-cache.db"
  }
}
```

### 2. Balanced Agent (Most Common)
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
      "description": "Code generation and debugging",
      "cache_ttl": 1800
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/balanced-cache.db"
  }
}
```

### 3. Power User Agent (Full Featured)
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
      "description": "Code generation and debugging",
      "cache_ttl": 1800
    },
    "creative": {
      "name": "llama3.1:8b",
      "description": "Creative writing and storytelling",
      "cache_ttl": 7200
    },
    "analysis": {
      "name": "llama3.1:13b",
      "description": "Deep analysis and reasoning",
      "cache_ttl": 3600
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/power-cache.db"
  }
}
```

## Specialized Configurations

### Email Assistant Agent
```json
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
      "description": "Draft professional responses",
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
```

### Code Review Agent
```json
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
```

### Creative Writing Agent
```json
{
  "default_model": "brainstorm",
  "models": {
    "brainstorm": {
      "name": "llama3.2:3b",
      "description": "Generate ideas and concepts",
      "cache_ttl": 900
    },
    "develop": {
      "name": "llama3.1:8b",
      "description": "Develop stories and content",
      "cache_ttl": 3600
    },
    "refine": {
      "name": "llama3.1:13b",
      "description": "Refine and polish final content",
      "cache_ttl": 7200
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/creative-cache.db"
  }
}
```

### Data Analysis Agent
```json
{
  "default_model": "parse",
  "models": {
    "parse": {
      "name": "llama3.2:3b",
      "description": "Parse and structure data",
      "cache_ttl": 1800
    },
    "analyze": {
      "name": "llama3.1:8b",
      "description": "Statistical analysis and insights",
      "cache_ttl": 3600
    },
    "visualize": {
      "name": "llama3.1:13b",
      "description": "Create visualizations and reports",
      "cache_ttl": 7200
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/data-cache.db"
  }
}
```

## Performance-Optimized Configurations

### High-Traffic Agent (Redis Backend)
```json
{
  "default_model": "general",
  "models": {
    "general": {
      "name": "llama3.2:3b",
      "description": "High-volume general queries",
      "cache_ttl": 7200
    }
  },
  "cache": {
    "backend": "redis",
    "host": "localhost",
    "port": 6379,
    "db": 0
  }
}
```

### Resource-Constrained Agent
```json
{
  "default_model": "general",
  "models": {
    "general": {
      "name": "llama3.2:3b",
      "description": "Lightweight for limited resources",
      "cache_ttl": 1800
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/light-cache.db",
    "max_size": "500MB"
  }
}
```

### Development Agent (Debug Mode)
```json
{
  "default_model": "debug",
  "models": {
    "debug": {
      "name": "llama3.2:3b",
      "description": "Debug and development assistance",
      "cache_ttl": 900
    },
    "explain": {
      "name": "llama3.1:8b",
      "description": "Detailed explanations",
      "cache_ttl": 3600
    }
  },
  "cache": {
    "backend": "sqlite",
    "path": "~/.config/submodels/dev-cache.db"
  }
}
```

## Dynamic Configuration Examples

### Time-Based Model Selection
```python
def get_model_for_time_of_day():
    """Select model based on time of day."""
    hour = datetime.now().hour
    
    if 6 <= hour < 12:  # Morning - fresh thinking
        return "creative"
    elif 12 <= hour < 18:  # Afternoon - analytical
        return "analysis"
    else:  # Evening - general
        return "general"
```

### Context-Based Model Selection
```python
def get_model_for_context(context):
    """Select model based on conversation context."""
    
    if "code" in context or "programming" in context:
        return "coding"
    elif "creative" in context or "write" in context:
        return "creative"
    elif "analyze" in context or "data" in context:
        return "analysis"
    else:
        return "general"
```

### Load-Based Model Selection
```python
def get_model_for_load(system_load):
    """Select model based on system load."""
    
    if system_load < 30:  # Low load
        return "analysis"  # Use best model
    elif system_load < 70:  # Medium load
        return "general"   # Use balanced model
    else:  # High load
        return "general"   # Use fastest model
```

## Testing Your Configuration

### Health Check Script
```python
#!/usr/bin/env python3
# test-config.py

from submodel_manager import SubmodelManager

def test_configuration():
    """Test your submodel configuration."""
    
    print("🧠 Testing Submodel Configuration...")
    
    try:
        manager = SubmodelManager()
        
        # Test each model
        for model_name, model_config in manager.config["models"].items():
            print(f"\nTesting {model_name} ({model_config['name']})...")
            
            try:
                response = manager.query(f"Test query for {model_name}", model=model_name)
                print(f"✅ {model_name}: Working")
                print(f"   Response: {response[:50]}...")
            except Exception as e:
                print(f"❌ {model_name}: Failed - {e}")
        
        # Test cache backend
        print(f"\nTesting cache backend...")
        stats = manager.get_stats()
        print(f"✅ Cache backend: {stats['backend']}")
        print(f"✅ Hit rate: {stats['hit_rate']}")
        
        print("\n✅ Configuration test complete!")
        
    except Exception as e:
        print(f"❌ Configuration test failed: {e}")

if __name__ == "__main__":
    test_configuration()
```

### Performance Benchmark
```python
#!/usr/bin/env python3
# benchmark.py

import time
from submodel_manager import SubmodelManager

def benchmark_performance():
    """Benchmark submodel system performance."""
    
    print("📊 Benchmarking Submodel Performance...")
    
    manager = SubmodelManager()
    
    test_queries = [
        "What is artificial intelligence?",
        "Explain machine learning in simple terms",
        "How does neural networks work?",
        "What are the applications of AI?"
    ]
    
    # Cold start (first query)
    print("\n🥶 Cold start performance...")
    start = time.time()
    response = manager.query(test_queries[0], model="general")
    cold_time = time.time() - start
    print(f"Cold start: {cold_time:.2f}s")
    
    # Warm cache performance
    print("\n🔥 Warm cache performance...")
    warm_times = []
    for query in test_queries:
        start = time.time()
        response = manager.query(query, model="general")
        warm_time = time.time() - start
        warm_times.append(warm_time)
        print(f"Warm query: {warm_time:.2f}s")
    
    # Statistics
    avg_warm = sum(warm_times) / len(warm_times)
    stats = manager.get_stats()
    
    print(f"\n📈 Performance Summary:")
    print(f"   Cold start: {cold_time:.2f}s")
    print(f"   Average warm: {avg_warm:.2f}s")
    print(f"   Cache hit rate: {stats['hit_rate']}")
    print(f"   Total queries: {stats['queries']}")

if __name__ == "__main__":
    benchmark_performance()
```

## Migration Guide

### From Single Model
```python
# Before: Single model
response = ollama.run("llama3.2:3b", prompt)

# After: Submodel system
from submodel_manager import SubmodelManager
manager = SubmodelManager()
response = manager.query(prompt, model="general")
```

### From Basic Caching
```python
# Before: Basic caching
cache = {}
if prompt in cache:
    return cache[prompt]
else:
    response = ollama.run(model, prompt)
    cache[prompt] = response
    return response

# After: Intelligent caching
from submodel_manager import SubmodelManager
manager = SubmodelManager()
return manager.query(prompt, model="general")
```

**Choose the configuration that best fits your agent's needs and system resources!** 🎯