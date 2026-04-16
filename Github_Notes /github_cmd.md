# Git/GitHub Workflow: Create Repo → Push Frontend Files → New Branch → Pull Request → Merge

## 1. Create a new repository on GitHub
Go to GitHub → click **New Repository** → name it (e.g., `frontend-app`) → create.

## 2. Initialize Git locally and connect to GitHub
```bash
cd my-frontend-project          # go into your project folder
git init                        # initialize Git
git remote add origin https://github.com/username/frontend-app.git
```

## 3. Add and commit all frontend files
```bash
git add .                       # stage all files
git commit -m "Initial commit with frontend files"
```

## 4. Push to GitHub main branch
```bash
git branch -M main              # rename branch to main
git push -u origin main         # push code to GitHub
```

## 5. Make changes locally
Edit your frontend files (e.g., update UI, fix bugs).

## 6. Create a new branch for changes
```bash
git checkout -b feature-update-ui
```

## 7. Stage and commit changes in the new branch
```bash
git add .
git commit -m "Updated UI components"
```

## 8. Push the new branch to GitHub
```bash
git push origin feature-update-ui
```

## 9. Open a Pull Request (PR)
Go to GitHub → you'll see a prompt to create a Pull Request for `feature-update-ui`.

Click **Compare & Pull Request** → add a description of your changes → submit the PR.

## 10. Review and Merge
Team members (or you, if solo) review the Pull Request.

Once approved, click **Merge Pull Request** → confirm merge into main.

## 11. Update local main branch
```bash
git checkout main
git pull origin main
```
