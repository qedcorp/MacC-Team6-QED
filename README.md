# MacC-Team6-QED

## Installation

### Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### SwiftLint

```bash
brew install swiftlint
```

---

## Collaboration

[Git-flow](https://danielkummer.github.io/git-flow-cheatsheet/) 브랜치 전략을 사용합니다.

### Workflow

1. 어떤 작업을 시작하기 전에 GitHub에 해당 작업에 대한 Issue를 등록합니다.
2. `feature/*` `bugfix/*` Branch에서 해당 작업을 진행합니다.
3. 작업이 완료되면 `develop` Branch로 Pull Request를 생성합니다.
4. 다음 조건이 통과하면 해당 Pull Request를 Merge 할 수 있습니다.
    1. Xcode Cloud를 통해 Build, Test가 성공
    2. 한 명 이상의 팀원이 코드 리뷰를 진행하고 Approve 처리
5. 배포가 필요하면 `release/[VERSION]` Branch를 생성하고, TestFlight를 통해 충분한 테스트를 거친 후, `main` Branch로 Pull Request를 생성합니다.
6. 해당 Pull Request를 Merge할 수 있는 조건은 4번 내용과 같습니다.

### CI/CD Pipeline

- 아래 파이프라인은 Xcode Cloud와 Github Actions으로 자동화되어 있으며, build number도 매번 자동으로 증가합니다.
- `develop` Branch에 Pull Request를 생성하면 Build, Test가 진행됩니다.
- `release/*` Branch에 변경사항이 생기면 내부 테스트용 TestFlight 빌드가 업로드됩니다.
- `main` Branch에 `release/*` Branch가 Merge 되면 release tag가 생성됩니다.
- release tag가 생성되면 Build, Test, 그리고 App Store 배포용 TestFlight 빌드가 업로드됩니다.
