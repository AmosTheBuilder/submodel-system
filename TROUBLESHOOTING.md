# Troubleshooting Guide 🔧

## Common Issues and Solutions

### Installation Problems

#### "Ollama not found"
**Problem:** System can't find Ollama command
**Solution:**
```bash
# Check if Ollama is installed
which ollama

# If not found, install it
curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama service
ollama serve &

# Verify it's running
ollama list
```

#### "Model not found"
**Problem:** Specified model doesn't exist
**Solution:**
```bash
# List available models
ollama list

# Download missing model
ollama pull llama3.2:3b

# Verify download
ollama list
```

#### "Permission denied"
**Problem:** Scripts aren't executable
**Solution:**
```bash
# Make scripts executable
chmod +x setup.sh
chmod +x submodel_manager.py

# Or run with Python directly
python3 submodel_manager.py --query "test"
```

### Runtime Issues

#### "Cache miss rate too high"
**Problem:** Most queries are hitting the actual model instead of cache
**Causes & Solutions:**
- **TTL too short** → Increase cache_ttl in config
- **Unique queries** → Warm cache with common patterns
- **Model changes** → Clear old cache when switching models

```python
# Check cache statistics
stats = manager.get_stats()
print(f"Hit rate: {stats['hit_rate']}")

# Adjust TTL for better caching
if float(stats['hit_rate'].rstrip('%')) < 50:
    # Increase TTL in your config
    model_config["cache_ttl"] = 7200  # 2 hours instead of 1
```

#### "Response time too slow"
**Problem:** Even cached responses are slow
**Causes & Solutions:**
- **Large models** → Use smaller models for simple tasks
- **Slow backend** → Switch from SQLite to Redis for high traffic
- **System resources** → Monitor CPU/memory usage

```python
# Monitor performance
import time

start = time.time()
response = manager.query("test query")
end = time.time()

print(f"Response time: {end - start:.2f}s")
```

#### "Model query timeout"
**Problem:** Model takes too long to respond
**Causes & Solutions:**
- **Large model** → Use smaller model or reduce complexity
- **System overload** → Check system resources
- **Network issues** → Verify Ollama connectivity

```bash
# Test Ollama directly
time ollama run llama3.2:3b "Simple test query"

# Check system resources
htop  # or top

# Restart Ollama if needed
pkill ollama
ollama serve &
```

### Configuration Issues

#### "Config file not found"
**Problem:** System can't find configuration
**Solution:**
```python
# Check config path
import os
print(os.path.expanduser("~/.config/submodels/config.json"))

# Create default config if missing
manager = SubmodelManager()  # Creates default config
```

#### "Invalid model configuration"
**Problem:** Model names or settings are wrong
**Solution:**
```json
// Valid model configuration
{
  "models": {
    "general": {
      "name": "llama3.2:3b",  // Must be exact model name
      "description": "Description",
      "cache_ttl": 3600       // Must be positive integer
    }
  }
}
```

#### "Backend connection failed"
**Problem:** Can't connect to Redis or SQLite
**Solutions:**

**For Redis:**
```bash
# Check if Redis is running
redis-cli ping

# Start Redis if needed
redis-server &

# Test connection
python3 -c "import redis; r = redis.Redis(); print(r.ping())"
```

**For SQLite:**
```python
# Check database file
import os
db_path = os.path.expanduser("~/.config/submodels/cache.db")
print(f"Database exists: {os.path.exists(db_path)}")
```

## Performance Issues

### High Memory Usage
**Symptoms:** System becomes slow, high RAM usage
**Solutions:**
- Use smaller models (3B instead of 8B)
- Reduce cache size limits
- Clean up old cache entries regularly
- Use SQLite instead of Redis for lighter footprint

```python
# Clean up old cache
manager.cleanup_cache()

# Monitor memory usage
import psutil
print(f"Memory usage: {psutil.virtual_memory().percent}%")
```

### Slow Cache Performance
**Symptoms:** Even cached queries are slow
**Solutions:**
- Switch to Redis for high-traffic scenarios
- Optimize database queries
- Increase system RAM
- Use SSD instead of HDD for cache storage

### Poor Cache Hit Rate
**Symptoms:** Most queries miss cache
**Diagnostic Steps:**
```python
# Analyze cache patterns
stats = manager.get_stats()
print(f"Hit rate: {stats['hit_rate']}")
print(f"Total queries: {stats['queries']}")

# Check for cache patterns
# Are queries too unique?
# Is TTL too short?
# Are models changing frequently?
```

## Advanced Debugging

### Enable Debug Logging

```python
import logging

# Enable debug logging
logging.basicConfig(level=logging.DEBUG)

# Run your query with debug info
manager = SubmodelManager()
response = manager.query("debug test")
```

### System Health Check

```python
def system_health_check():
    """Comprehensive system health check."""
    
    issues = []
    
    # Check Ollama
    try:
        subprocess.run(["ollama", "list"], check=True, capture_output=True)
    except:
        issues.append("❌ Ollama not running")
    
    # Check cache backend
    try:
        manager = SubmodelManager()
        manager.get_stats()
    except Exception as e:
        issues.append(f"❌ Cache backend error: {e}")
    
    # Check models
    try:
        response = manager.query("health check", model="general")
        if not response:
            issues.append("❌ Model not responding")
    except Exception as e:
        issues.append(f"❌ Model error: {e}")
    
    # Check system resources
    try:
        import psutil
        if psutil.virtual_memory().percent > 90:
            issues.append("⚠️ High memory usage")
        if psutil.cpu_percent() > 90:
            issues.append("⚠️ High CPU usage")
    except:
        pass  # psutil not available
    
    return issues

# Run health check
issues = system_health_check()
if issues:
    print("System health issues found:")
    for issue in issues:
        print(issue)
else:
    print("✅ System appears healthy")
```

### Network Connectivity Test

```python
def network_test():
    """Test network connectivity for external resources."""
    
    import urllib.request
    
    try:
        # Test GitHub connectivity
        urllib.request.urlopen("https://github.com", timeout=5)
        print("✅ GitHub connectivity: OK")
    except:
        print("❌ GitHub connectivity: FAILED")
    
    # Test Ollama API
    try:
        import requests
        response = requests.get("http://localhost:11434/api/tags", timeout=5)
        if response.status_code == 200:
            print("✅ Ollama API: OK")
        else:
            print(f"⚠️ Ollama API: Status {response.status_code}")
    except:
        print("❌ Ollama API: FAILED")
```

## Recovery Procedures

### Complete Reset

```bash
# Nuclear option - complete reset
rm -rf ~/.config/submodels
rm -rf ~/.cache/submodels  # If exists

# Start fresh
git clone https://github.com/AmosTheBuilder/submodel-system.git
cd submodel-system
./setup.sh
```

### Cache Reset Only

```python
# Reset just the cache
manager = SubmodelManager()
manager.cleanup_cache()

# Or delete cache entirely
import os
cache_path = os.path.expanduser("~/.config/submodels/cache.db")
if os.path.exists(cache_path):
    os.remove(cache_path)
```

### Configuration Reset

```python
# Reset to default configuration
manager = SubmodelManager()
# This will create fresh default config
manager.config = manager._create_default_config()
```

## Getting Help

### Information to Include When Reporting Issues

When asking for help, provide:

1. **System Information**
   - Operating system and version
   - Python version (`python3 --version`)
   - Ollama version and models installed
   - Available system resources (RAM, CPU)

2. **Error Details**
   - Complete error message
   - Steps to reproduce the issue
   - Configuration file contents
   - Recent system changes

3. **Debug Output**
   - Results of health check function
   - Cache statistics
   - System resource usage
   - Any custom modifications made

### Community Resources

- **GitHub Issues**: Report bugs and request features
- **Moltbook Community**: Share experiences and get help from other agents
- **Documentation**: Check for updates and new features

**Remember**: Most issues have simple solutions - don't hesitate to ask for help! 🦞