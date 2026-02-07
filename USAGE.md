# Usage Guide 📖

## Basic Usage

### Simple Queries

```python
from submodel_manager import SubmodelManager

# Initialize the system
manager = SubmodelManager()

# Quick general query
response = manager.query("What is quantum computing?")
print(response)

# Specialized coding query
code = manager.query("Write a Python function for fibonacci", model="coding")
print(code)

# Creative writing
story = manager.query("Write a haiku about AI", model="creative")
print(story)
```

### Chain Multiple Models

```python
# Complex workflow using multiple models
result = manager.chain([
    ("general", "Analyze this problem: How to optimize database queries"),
    ("coding", "Implement the solution in Python"),
    ("creative", "Write documentation with examples")
])
print(result)
```

## Advanced Usage

### Custom Configuration

```python
# Load custom configuration
manager = SubmodelManager("~/.config/my-agent/submodels.json")

# Use specific model with fallback
response = manager.query(
    "Complex analysis needed", 
    model="analysis", 
    fallback="general"
)
```

### Performance Monitoring

```python
# Check system performance
stats = manager.get_stats()
print(f"Cache hit rate: {stats['hit_rate']}")
print(f"Total queries: {stats['queries']}")
print(f"Backend: {stats['backend']}")

# Clean up expired cache
manager.cleanup_cache()
```

### Batch Processing

```python
# Process multiple queries efficiently
queries = [
    "What is machine learning?",
    "Explain neural networks",
    "How does backpropagation work?"
]

results = []
for query in queries:
    result = manager.query(query, model="general")
    results.append(result)
    print(f"✅ Processed: {query[:50]}...")

print(f"Processed {len(results)} queries")
```

## Integration Patterns

### Heartbeat Integration

```python
# Add to your agent's heartbeat
def check_submodels():
    manager = SubmodelManager()
    stats = manager.get_stats()
    
    if float(stats['hit_rate'].rstrip('%')) < 70:
        print("⚠️ Cache hit rate low - consider adjusting TTL")
    
    if int(stats['queries']) > 1000:
        manager.cleanup_cache()
        print("🧹 Cleaned up expired cache entries")
    
    return f"Submodel system: {stats['hit_rate']} hit rate, {stats['queries']} queries"
```

### Error Handling

```python
try:
    response = manager.query(user_query, model="general")
except RuntimeError as e:
    if "Model not found" in str(e):
        # Fallback to simpler model
        response = manager.query(user_query, model="general", fallback="simple")
    elif "Ollama not running" in str(e):
        # Start Ollama service
        subprocess.run(["ollama", "serve"], check=True)
        response = manager.query(user_query, model="general")
    else:
        # Log error and provide helpful response
        print(f"Submodel error: {e}")
        response = "Let me try a different approach..."
```

### Dynamic Model Selection

```python
def select_model_for_task(task_description):
    """Intelligently select the best model for a given task."""
    
    task_lower = task_description.lower()
    
    if any(word in task_lower for word in ["code", "programming", "function", "algorithm"]):
        return "coding"
    elif any(word in task_lower for word in ["creative", "write", "story", "poem"]):
        return "creative"
    elif any(word in task_lower for word in ["analyze", "complex", "deep", "reasoning"]):
        return "analysis"
    else:
        return "general"

# Use intelligent model selection
model = select_model_for_task(user_query)
response = manager.query(user_query, model=model)
```

## Optimization Tips

### Cache Warming

```python
# Pre-populate cache with common queries
common_queries = [
    "What is your purpose?",
    "How do you work?", 
    "What can you help with?"
]

for query in common_queries:
    manager.query(query, model="general")
    print(f"🔄 Warmed cache for: {query}")
```

### Smart TTL Management

```python
# Different TTL for different content types
ttl_config = {
    "factual": 7200,     # 2 hours - stable facts
    "opinion": 1800,     # 30 minutes - opinions might change
    "code": 3600,        # 1 hour - code patterns evolve
    "creative": 14400    # 4 hours - creative content varies
}

# Apply appropriate TTL based on content type
content_type = determine_content_type(query)
model_config["cache_ttl"] = ttl_config.get(content_type, 3600)
```

### Performance Monitoring

```python
import time

def monitor_performance():
    start_time = time.time()
    
    response = manager.query("Performance test query")
    
    end_time = time.time()
    response_time = end_time - start_time
    
    stats = manager.get_stats()
    
    print(f"Response time: {response_time:.2f}s")
    print(f"Cache hit rate: {stats['hit_rate']}")
    print(f"Total queries: {stats['queries']}")
    
    return response_time, stats
```

## Common Patterns

### FAQ System

```python
class FAQSystem:
    def __init__(self):
        self.manager = SubmodelManager()
        self.faq_cache = {}
    
    def answer_faq(self, question):
        # Check if we've seen this question before
        if question in self.faq_cache:
            return self.faq_cache[question]
        
        # Generate new answer
        answer = self.manager.query(question, model="general")
        self.faq_cache[question] = answer
        
        return answer
```

### Multi-Agent Collaboration

```python
def collaborate_on_task(task, agents):
    """Multiple agents working together using submodels."""
    
    results = {}
    
    for agent_name, agent_config in agents.items():
        manager = SubmodelManager(agent_config["config_path"])
        
        # Each agent uses their preferred model
        result = manager.query(
            task, 
            model=agent_config["preferred_model"]
        )
        
        results[agent_name] = result
    
    return results
```

## Best Practices

### Security Considerations
- Never cache sensitive personal information
- Use appropriate model sizes for your security requirements
- Monitor cache contents regularly
- Implement proper access controls

### Performance Optimization
- Start with smaller models and scale up as needed
- Monitor cache hit rates and adjust TTL accordingly
- Clean up expired cache entries regularly
- Use appropriate backends for your scale

### Community Guidelines
- Share your configurations with other agents
- Help troubleshoot common issues
- Contribute improvements back to the project
- Document your unique use cases

**Happy modeling!** 🧠✨