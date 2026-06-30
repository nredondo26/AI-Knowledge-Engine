# SLAM — Simultaneous Localization and Mapping

## Descripción del dominio

SLAM (Simultaneous Localization and Mapping) es el problema computacional de construir o actualizar un mapa de un entorno desconocido mientras se mantiene un seguimiento de la localización del agente dentro de él. Es fundamental en robótica móvil autónoma: vehículos autónomos, drones, robots de limpieza, AGVs industriales y realidad aumentada. SLAM combina datos de sensores (LIDAR, cámara, IMU, encoder) con técnicas de estimación probabilística (filtro de Kalman, filtro de partículas, optimización de grafos) para producir mapas consistentes y estimaciones de pose precisas.

## Áreas clave

- **SLAM basado en filtros**: EKF-SLAM (Extended Kalman Filter), FastSLAM (Rao-Blackwellized Particle Filter). Representan el estado como distribución gaussiana o conjunto de partículas. Limitados por linealización y escalabilidad
- **SLAM basado en grafos (Graph SLAM)**: Nodos = poses del robot, aristas = constraints (odometría, observaciones). Optimización no lineal (g2o, GTSAM, Ceres). Escalable a mapas grandes
- **LIDAR SLAM**: Usa nubes de puntos 3D/2D. ICP (Iterative Closest Point), NDT (Normal Distributions Transform), Cartographer (Google), Hector SLAM, KISS-ICP, LOAM, A-LOAM, Lego-LOAM
- **Visual SLAM (vSLAM)**: Cámaras monoculares, estéreo o RGB-D. ORB-SLAM3, DSO (Direct Sparse Odometry), SVO, LSD-SLAM, VINS-Mono (visual-inertial), OpenVSLAM
- **Visual-Inertial SLAM (VI-SLAM)**: Combina cámara + IMU para robustez en entornos con poca textura o movimiento rápido. VINS-Fusion, ORB-SLAM3 (IMU), ROVIOLI (maplab)
- **Semantic SLAM**: Incorpora información semántica (detección de objetos, segmentación). El mapa no solo es geométrico sino que contiene etiquetas (coche, pared, puerta, persona). DynaSLAM, Kimera
- **Loop Closure**: Detección de lugares ya visitados para corregir deriva acumulada. Bag of Visual Words, Scan Context (LIDAR), DBoW2/3, NetVLAD (deep learning)
- **Mapas**: Occupancy grid (2D, navegación plana), Point cloud (3D), OctoMap (3D probabilístico), TSDF (Truncated Signed Distance Function), Semantic map (con etiquetas)
- **Back-end de optimización**: g2o (General Graph Optimization), GTSAM (Georgia Tech Smoothing and Mapping), Ceres Solver, SE-Sync. Resuelven graph SLAM con factores

## Ejemplo: Graph SLAM con g2o

```cpp
// Nodo: vértices (poses y landmarks) y aristas (constraints)
#include <g2o/core/sparse_optimizer.h>
#include <g2o/core/block_solver.h>
#include <g2o/solvers/csparse/linear_solver_csparse.h>
#include <g2o/types/slam2d/types_slam2d.h>

g2o::SparseOptimizer optimizer;
auto solver = g2o::make_unique<g2o::BlockSolverX>(
    g2o::make_unique<g2o::LinearSolverCSparse<g2o::BlockSolverX::PoseMatrixType>>());
optimizer.setAlgorithm(new g2o::OptimizationAlgorithmLevenberg(std::move(solver)));

// Añadir vértice de pose
for (int i = 0; i < num_poses; ++i) {
    auto *v = new g2o::VertexSE2();
    v->setId(i);
    if (i == 0) v->setFixed(true);
    v->setEstimate(poses[i]);
    optimizer.addVertex(v);
}

// Añadir aristas de odometría
for (int i = 1; i < num_poses; ++i) {
    auto *e = new g2o::EdgeSE2();
    e->setVertex(0, optimizer.vertex(i-1));
    e->setVertex(1, optimizer.vertex(i));
    e->setMeasurement(odometry[i]);
    e->setInformation(Eigen::Matrix3d::Identity());
    optimizer.addEdge(e);
}

optimizer.initializeOptimization();
optimizer.optimize(10); // 10 iteraciones
```

## Tecnologías principales

| Algoritmo | Tipo | Sensores | Loop Closure | Licencia |
|-----------|------|----------|-------------|----------|
| Cartographer | LIDAR + IMU | 2D/3D LiDAR | Scan-to-map, submap | Apache 2.0 |
| ORB-SLAM3 | Visual | Mono, Stereo, RGB-D, IMU | DBoW2, ORB features | GPL v3 |
| LOAM / A-LOAM | LIDAR | 3D LiDAR | No nativo | BSD |
| VINS-Fusion | Visual-Inertial | Mono + IMU, Stereo | Sí | GPL v3 |
| KISS-ICP | LIDAR | 3D LiDAR | Naive | MIT |
| RTAB-Map | RGB-D / LIDAR | RGB-D, Stereo, LiDAR | Sí, memoria a largo plazo | BSD |
| OpenVSLAM | Visual | Mono, Stereo, RGB-D | DBoW2 | 2-clause BSD |

## Buenas prácticas

- Usar LIDAR SLAM para entornos interiores grandes y repetitivos (robots móviles)
- Usar Visual SLAM para entornos exteriores con buena iluminación y textura
- Combinar IMU para robustez en giros rápidos y movimientos bruscos
- Implementar loop closure con detección de lugar para corregir deriva acumulada
- Usar OctoMap (3D) para navegación con obstáculos en altura
- Para entornos dinámicos, usar SLAM semántico que ignore objetos en movimiento
- Evaluar precisión con métricas ATE (Absolute Trajectory Error) y RPE (Relative Pose Error)
- Usar datasets (TUM RGB-D, KITTI, EuRoC) para benchmarking de algoritmos
- En robots con restricciones de cómputo, considerar FastSLAM o filtro de partículas

## Referencias

- *Probabilistic Robotics* (Thrun, Burgard, Fox) — texto fundamental de SLAM
- *Multiple View Geometry* (Hartley, Zisserman) — base matemática para SLAM visual
- ORB-SLAM3 paper: Campos et al. (2021), IEEE Trans. Robotics
- Cartographer paper: Hess et al. (2016), IROS
- KITTI Vision Benchmark: cvlibs.net/datasets/kitti
- TUM RGB-D Benchmark: cvg.cit.tum.de/data/datasets/rgbd-dataset
