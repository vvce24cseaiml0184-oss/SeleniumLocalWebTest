# NEW JOB: Executes sequentially only after validation tests pass perfectly
build-and-publish-docker:
  needs: selenium-test
  runs-on: ubuntu-latest
  if: github.event_name == 'push' # Only push to registry on formal merges/pushes
  steps:
    - name: Checkout source code
      uses: actions/checkout@v4

    - name: Log in to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets::DOCKERHUB_USERNAME }}
        password: ${{ secrets::DOCKERHUB_TOKEN }}

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Build and Push Docker Image
      uses: docker/build-push-action@v5
      with:
        context: .
        file: ./Dockerfile
        push: true
        tags: |
          ${{ secrets.DOCKERHUB_USERNAME }}/selenium-testng-automation:latest
          ${{ secrets.DOCKERHUB_USERNAME }}/selenium-testng-automation:${{ github.sha }}
