# Single Place for Education Frontend

## Serving the application

### Requirements

- Docker

### Environment variables

- `CONTENTFUL_SPACE_ID` - The space ID provided by Contentful
- `CONTENTFUL_ACCESS_KEY` - The access key provided by Contentful

### Using make serve

To serve the application with the environment variables, run:

```bash
env CONTENTFUL_SPACE_ID=meow CONTENTFUL_ACCESS_KEY=secureWoof make serve
```
