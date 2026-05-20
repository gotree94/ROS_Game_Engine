# ROS + Game Engine SIL 플랫폼 버전 호환성 분석

> 분석일: 2026-05-20
> SIL = Software-in-the-Loop

---

## 1. ROS + Unity

### 지원 버전

| 플랫폼 | 지원 버전 | 비고 |
|---|---|---|
| **ROS1** | Melodic (Ubuntu 18.04), Noetic (Ubuntu 20.04) | ROS-TCP-Connector 공식 지원 |
| **ROS2** | Foxy, Galactic, **Humble**, Iron, **Jazzy**, Rolling | ROS-TCP-Endpoint가 rclpy 기반이라 ROS2 distro에 거의 무관 |
| **Unity** | **2020.2+** (공식), 2021.3 LTS, 2022.3 LTS, 2023.3+, Unity 6 | ROS-TCP-Connector 패키지 요구사항 |
| **URDF Importer** | Unity 2020.2+ | Unity Robotics Hub 내 패키지 |
| **OS** | Windows 10/11, Linux (Ubuntu 20.04/22.04/24.04), macOS | ROS endpoint는 Linux 권장 |

### 실제 조합 예시

| 조합 | ROS | Unity | 상태 |
|---|---|---|---|
| Classic | ROS1 Noetic | Unity 2020.3 LTS | ✅ 안정 |
| 최신 LTS | **ROS2 Humble** | **Unity 2022.3 LTS** | ✅ **가장 추천** |
| 최신 | ROS2 Jazzy | Unity 6 (6000.0) | ✅ 가능 |
| 엣지 | ROS2 Rolling | Unity 6 | ✅ 가능 |

### 핵심 도구

| 구성요소 | 설명 | URL |
|---|---|---|
| **ROS-TCP-Connector** | Unity ↔ ROS 양방향 TCP 통신 (ROS1/ROS2) | https://github.com/Unity-Technologies/ROS-TCP-Connector |
| **ROS-TCP-Endpoint** | ROS 측 Python endpoint 서버 | https://github.com/Unity-Technologies/ROS-TCP-Endpoint |
| **Unity Robotics Hub** | 공식 ROS 통합 샘플/튜토리얼 모음 | https://github.com/Unity-Technologies/Unity-Robotics-Hub |
| **URDF Importer** | ROS URDF → Unity Scene 변환 | https://github.com/Unity-Technologies/URDF-Importer |
| **Visualizations Package** | ROS 메시지 시각화 (RViz-like) | ROS-TCP-Connector 내 포함 |

### 특이사항

> ROS-TCP-Connector는 TCP 소켓 기반이라 ROS 버전에 독립적. ROS-TCP-Endpoint만 해당 ROS distro 환경에서 실행하면 됨. Unity는 2020.2 이후면 전부 호환.

---

## 2. ROS + Unreal Engine

### 2A. CARLA Simulator (자율주행 특화)

#### 지원 버전

| 플랫폼 | 지원 버전 | 비고 |
|---|---|---|
| **Unreal Engine** | **UE4.26** (stable, `ue4-dev` 브랜치) | 프로덕션 안정 버전 |
| | **UE5.5** (개발중, `ue5-dev` 브랜치) | 최신, 고사양 GPU 필요 |
| **ROS1** | Noetic | ros-bridge 공식 지원 |
| **ROS2** | **Humble**, Jazzy | ros-bridge ROS2 지원 |
| **OS** | Ubuntu 22.04, **Ubuntu 24.04** (UE5.5), **Windows 11** (UE5.5) | Windows 10 / Ubuntu 20.04는 UE5.5 미지원 |
| **Python** | 3.8+ | CARLA Python API |
| **GPU** | NVIDIA RTX 3070+ (UE4), RTX 4090/5090 (UE5) | VRAM 8GB+ / 16GB+ |

#### 조합 표

| UE 버전 | CARLA 브랜치 | ROS 지원 | 추천 용도 |
|---|---|---|---|
| UE 4.26 | `ue4-dev` | ROS1 Noetic / ROS2 Humble | ✅ 안정적인 자율주행 SIL |
| UE 5.5 | `ue5-dev` | ROS2 Humble / Jazzy | 🔬 최신 그래픽, 실험적 |

#### 구성요소

| 구성요소 | 설명 | URL |
|---|---|---|
| **CARLA Simulator** | 오픈소스 자율주행 시뮬레이터 | https://github.com/carla-simulator/carla |
| **ROS Bridge** | CARLA ↔ ROS 양방향 브리지 | https://github.com/carla-simulator/ros-bridge |
| **CARLA 문서** | 설치 및 튜토리얼 | https://carla.readthedocs.io |

> **제약:** CARLA는 **자율주행 전용**임. 일반 로봇 SIL에는 부적합.

---

### 2B. TempoROS (일반 로봇 SIL)

#### 지원 버전

| 플랫폼 | 지원 버전 | 비고 |
|---|---|---|
| **Unreal Engine** | **5.4, 5.5, 5.6, 5.7** | 공식 명시 |
| **ROS2** | **Humble** | rclcpp 네이티브 바인딩 |
| **OS** | Linux (Ubuntu 22.04/24.04), Windows 10/11, macOS 13+ (Apple Silicon) | 크로스 플랫폼 |
| **방식** | rclcpp 직접 사용 (브리지 아님) | UE5 C++에서 직접 ROS2 노드 실행 |

#### 조합 표

| UE 버전 | ROS2 | OS | 상태 |
|---|---|---|---|
| UE 5.4 | Humble | Ubuntu 22.04 | ✅ 안정 |
| UE 5.5 | Humble | Ubuntu 22.04/24.04, Windows 11 | ✅ 안정 |
| UE 5.6 | Humble | 전 플랫폼 | ✅ 안정 |
| UE 5.7 | Humble | 전 플랫폼 | ✅ 최신 |
| UE 5.5+ | Jazzy | — | ⚠️ 공식 명시되지 않음 (직접 빌드 필요) |

#### 구성요소

| 구성요소 | 설명 | URL |
|---|---|---|
| **TempoROS** | UE5 네이티브 ROS2 통합 플러그인 | https://github.com/tempo-sim/TempoROS |
| **Tempo (전체 스위트)** | Tempo 시뮬레이션 플러그인 모음 | https://github.com/tempo-sim/Tempo |

---

### 2C. AirSim (Microsoft, 레거시)

| 플랫폼 | 버전 | 비고 |
|---|---|---|
| UE | 4.25~4.27 | 메인 지원 |
| Unity | 실험적 지원 | 더 이상 활발한 개발 없음 |
| ROS | Noetic, Humble | AirSim ROS wrapper 별도 |
| 상태 | **사실상 유지보수 모드** → Project AirSim으로 대체 중 |

---

## 3. ROS + Blender

### 지원 버전

| 플랫폼 | 지원 버전 | 비고 |
|---|---|---|
| **Blender** | **3.6 LTS**, **4.0**, **4.1**, **4.2 LTS**, **4.3** | BlenderProc이 특정 Blender 바이너리 사용 |
| **BlenderProc** | 2.8.x (최신) | `pip install blenderproc` |
| **bpy (pip)** | bpy 3.4~4.0 → Python 3.10 | Blender 3.6 기반 |
| | bpy 4.1~4.3 → **Python 3.11** | Blender 4.x 기반 |
| **ROS 연결** | **직접 연결 없음** | 실시간 ROS ↔ Blender 통신 미지원 |
| **데이터 연동** | 파일 기반 (.hdf5, COCO, BOP) | ROS2 `.db3` 변환 스크립트 필요 |

### 호환성 표

| Blender | BlenderProc | Python | ROS 연동 방식 | SIL 실시간 폐루프 |
|---|---|---|---|---|
| 3.6 LTS | ✅ 2.8.x | 3.10 | 파일 익스포트 → 외부 변환 | ❌ 불가능 |
| 4.0 | ✅ 2.8.x | 3.10 | 파일 익스포트 → 외부 변환 | ❌ 불가능 |
| 4.1 | ✅ 2.8.x | 3.11 | 파일 익스포트 → 외부 변환 | ❌ 불가능 |
| 4.2 LTS | ✅ 2.8.x | 3.11 | 파일 익스포트 → 외부 변환 | ❌ 불가능 |
| 4.3 | ✅ 2.8.x | 3.11 | 파일 익스포트 → 외부 변환 | ❌ 불가능 |

### 구성요소

| 구성요소 | 설명 | URL |
|---|---|---|
| **BlenderProc** | Blender 기반 합성 데이터 생성 파이프라인 (DLR) | https://github.com/DLR-RM/BlenderProc |
| **Syclops** | 모듈형 합성 데이터 생성 파이프라인 | JOSS 2025 논문 |
| **CC Textures** | 무료 텍스처 데이터셋 (BlenderProc 사용) | https://cc0textures.com/ |

### 핵심 제약

> BlenderProc은 ROS 노드가 아니라 **독립형 렌더링 파이프라인**임. 실시간 ROS 컨트롤 루프(1kHz)와의 양방향 통신은 구조적으로 불가능. 오프라인 합성 데이터 생성용으로만 사용해야 함.

---

## 4. ROS2 Distro별 Ubuntu 버전 (참고)

| ROS2 Distro | 릴리즈 | EOL | Ubuntu | 권장 여부 |
|---|---|---|---|---|
| **Foxy** | 2020.06 | 2023.06 | 20.04 | ❌ EOL |
| **Galactic** | 2021.05 | 2022.12 | 20.04 | ❌ EOL |
| **Humble** | 2022.05 | **2027.05** | **22.04** | ✅ LTS, 최다 지원 |
| **Iron** | 2023.05 | 2024.11 | **22.04** | ❌ EOL |
| **Jazzy** | 2024.05 | **2029.05** | **24.04** | ✅ 최신 LTS |
| **Kilted** (preview) | 2026.05 예정 | — | **24.04** | 🔜 |
| Rolling | rolling | — | 24.04 | 🔬 개발용 |

---

## 5. 종합 평가

| 조합 | SIL 실시간 폐루프 | 합성 데이터 생성 | 추천 ROS 버전 | 추천 플랫폼 버전 | 종합 평가 |
|---|---|---|---|---|---|
| **ROS + Unity** | ✅ 완벽 지원 | ✅ 가능 | Humble / Jazzy | Unity 2022.3 LTS / Unity 6 | ⭐⭐⭐⭐⭐ **최우선** |
| **ROS + UE (CARLA)** | ✅ 자율주행 한정 | ✅ 가능 | Humble / Jazzy | UE4.26 (안정) / UE5.5 (최신) | ⭐⭐⭐⭐ 자율주행 한정 |
| **ROS + UE (TempoROS)** | ✅ 가능 | ✅ 가능 | Humble | UE 5.4~5.7 | ⭐⭐⭐ 초기 단계 |
| **ROS + Blender** | ❌ **불가능** | ✅ **매우 강력** | N/A (간접) | Blender 4.2 LTS + BlenderProc | ⭐⭐ SIL 불가, 데이터 생성 전용 |
| **ROS + Gazebo (기준선)** | ✅ 기본값 | ❌ 떨어짐 | 전 distro | Fortress / Harmonic | ⭐⭐⭐⭐ 무료, 기본 SIL |

### 최종 권장사항

| 시나리오 | 권장 조합 |
|---|---|
| **일반 로봇 SIL (팩토리, 물류, 매니퓰레이터, AMR)** | **ROS2 Humble + Unity 2022.3 LTS** |
| **자율주행 SIL** | **ROS2 Humble + CARLA (UE4.26)** |
| **고품질 합성 데이터 생성 (Perception 학습용)** | Blender 4.2 LTS + BlenderProc |
| **최신 그래픽 + 일반 로봇 SIL (실험적)** | **ROS2 Humble + UE5.5 + TempoROS** |
| **경량/교육용 SIL** | ROS2 Humble + Gazebo Harmonic |
