# Blockchain-Based Smart City Resilience Management

A comprehensive blockchain platform for managing urban resilience through transparent, decentralized infrastructure monitoring, risk assessment, and disaster management coordination.

## 🏙️ Overview

The Smart City Resilience Management system leverages blockchain technology to create a transparent, immutable, and coordinated approach to urban disaster preparedness and response. The platform consists of five interconnected smart contracts that work together to ensure comprehensive city resilience management.

## 🏗️ System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Infrastructure │    │ Risk Assessment │    │ Preparedness    │
│  Verification   │◄──►│   Contract      │◄──►│ Planning        │
│   Contract      │    │                 │    │   Contract      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         └────────────────────────┼────────────────────────┘
                                  │
         ┌────────────────────────▼────────────────────────┐
         │            Response Coordination                │
         │               Contract                          │
         └────────────────────────┬────────────────────────┘
                                  │
         ┌────────────────────────▼────────────────────────┐
         │            Recovery Tracking                    │
         │               Contract                          │
         └─────────────────────────────────────────────────┘
```

## 📋 Core Components

### 1. Infrastructure Verification Contract
**Purpose**: Validates and monitors critical city systems in real-time

**Key Features**:
- Continuous monitoring of essential infrastructure (power grids, water systems, transportation networks)
- Automated verification of system health and performance metrics
- Integration with IoT sensors and monitoring devices
- Immutable logging of infrastructure status changes
- Threshold-based alerting for system degradation

**Functions**:
- `registerInfrastructure()` - Add new infrastructure to monitoring
- `updateSystemStatus()` - Record real-time system health data
- `validateCriticalSystems()` - Perform comprehensive system checks
- `getInfrastructureHealth()` - Retrieve current system status

### 2. Risk Assessment Contract
**Purpose**: Identifies and evaluates resilience vulnerabilities across the city

**Key Features**:
- Multi-hazard risk modeling (natural disasters, cyber threats, infrastructure failures)
- Vulnerability scoring algorithms
- Historical data analysis for risk prediction
- Integration with weather services and threat intelligence feeds
- Automated risk level updates based on changing conditions

**Functions**:
- `assessRiskLevel()` - Calculate current city-wide risk score
- `identifyVulnerabilities()` - Detect system weaknesses
- `updateThreatIntelligence()` - Incorporate new risk data
- `generateRiskReport()` - Create comprehensive risk analysis

### 3. Preparedness Planning Contract
**Purpose**: Manages disaster readiness and emergency planning

**Key Features**:
- Resource inventory management (emergency supplies, equipment, personnel)
- Evacuation route optimization
- Emergency protocol storage and versioning
- Training schedule coordination
- Simulation and drill management
- Stakeholder notification systems

**Functions**:
- `createEmergencyPlan()` - Develop new response protocols
- `updateResourceInventory()` - Manage emergency resources
- `scheduleTrainingDrill()` - Coordinate preparedness exercises
- `validateReadinessLevel()` - Assess overall preparedness status

### 4. Response Coordination Contract
**Purpose**: Coordinates emergency response across all city departments and agencies

**Key Features**:
- Real-time incident management
- Multi-agency coordination protocols
- Resource deployment optimization
- Communication channel management
- Decision-making audit trails
- Automated escalation procedures

**Functions**:
- `declareEmergency()` - Initialize emergency response protocols
- `coordinateResponse()` - Manage multi-agency operations
- `deployResources()` - Allocate emergency resources
- `updateIncidentStatus()` - Track response progress
- `communicateWithStakeholders()` - Manage emergency communications

### 5. Recovery Tracking Contract
**Purpose**: Monitors and manages post-disaster recovery efforts

**Key Features**:
- Damage assessment documentation
- Recovery milestone tracking
- Resource allocation for rebuilding
- Progress reporting and transparency
- Lessons learned documentation
- Performance metrics analysis

**Functions**:
- `assessDamage()` - Document disaster impact
- `trackRecoveryProgress()` - Monitor rebuilding efforts
- `allocateRecoveryResources()` - Manage reconstruction resources
- `generateRecoveryReport()` - Create progress summaries
- `documentLessonsLearned()` - Capture improvement opportunities

## 🚀 Getting Started

### Prerequisites
- Node.js (v16 or higher)
- Hardhat development environment
- MetaMask or compatible Web3 wallet
- Access to Ethereum testnet (Goerli/Sepolia) or mainnet

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/your-org/smart-city-resilience.git
cd smart-city-resilience
```

2. **Install dependencies**
```bash
npm install
```

3. **Configure environment variables**
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. **Compile smart contracts**
```bash
npx hardhat compile
```

5. **Deploy contracts**
```bash
npx hardhat run scripts/deploy.js --network <network-name>
```

### Configuration

Create a `.env` file with the following variables:

```env
# Network Configuration
INFURA_PROJECT_ID=your_infura_project_id
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key

# Contract Addresses (after deployment)
INFRASTRUCTURE_CONTRACT=0x...
RISK_ASSESSMENT_CONTRACT=0x...
PREPAREDNESS_CONTRACT=0x...
RESPONSE_CONTRACT=0x...
RECOVERY_CONTRACT=0x...

# External API Keys
WEATHER_API_KEY=your_weather_api_key
IOT_GATEWAY_URL=your_iot_gateway_url
```

## 💻 Usage Examples

### Monitoring Infrastructure
```javascript
const infrastructure = await InfrastructureContract.deployed();

// Register new infrastructure
await infrastructure.registerInfrastructure(
    "PowerGrid_North",
    "electricity",
    "0x1234...", // IoT sensor address
    95 // Critical threshold
);

// Update system status
await infrastructure.updateSystemStatus(
    "PowerGrid_North",
    98, // Current performance
    "operational"
);
```

### Risk Assessment
```javascript
const riskAssessment = await RiskAssessmentContract.deployed();

// Perform risk analysis
const riskLevel = await riskAssessment.assessRiskLevel("flood", {
    weatherData: weatherFeed,
    historicalData: pastIncidents,
    currentConditions: sensorData
});

console.log(`Current flood risk level: ${riskLevel}`);
```

### Emergency Response
```javascript
const response = await ResponseContract.deployed();

// Declare emergency
await response.declareEmergency(
    "FLOOD001",
    "Major flooding in downtown area",
    3, // Severity level
    ["fire_dept", "police", "public_works"]
);

// Coordinate response
await response.coordinateResponse("FLOOD001", {
    resources: ["pumps", "sandbags", "rescue_boats"],
    personnel: 50,
    evacuationZones: ["zone_1", "zone_2"]
});
```

## 🔧 API Reference

### Infrastructure Verification Contract

#### Events
```solidity
event InfrastructureRegistered(bytes32 indexed id, string systemType);
event SystemStatusUpdated(bytes32 indexed id, uint256 performance);
event CriticalAlert(bytes32 indexed id, string alert);
```

#### Functions
```solidity
function registerInfrastructure(string memory id, string memory systemType, address sensor, uint256 threshold) external;
function updateSystemStatus(string memory id, uint256 performance, string memory status) external;
function getInfrastructureHealth(string memory id) external view returns (uint256, string memory);
```

### Risk Assessment Contract

#### Events
```solidity
event RiskLevelUpdated(string hazardType, uint256 riskScore);
event VulnerabilityIdentified(bytes32 indexed vulnerabilityId, uint256 severity);
event ThreatIntelligenceUpdated(string source, uint256 timestamp);
```

#### Functions
```solidity
function assessRiskLevel(string memory hazardType, bytes memory data) external returns (uint256);
function identifyVulnerabilities() external returns (bytes32[] memory);
function updateThreatIntelligence(string memory source, bytes memory data) external;
```

## 🔒 Security Considerations

### Access Control
- Role-based permissions for different city departments
- Multi-signature requirements for critical operations
- Time-locked emergency procedures
- Audit trails for all administrative actions

### Data Privacy
- Personal data encryption before on-chain storage
- Zero-knowledge proofs for sensitive operations
- GDPR compliance mechanisms
- Selective data sharing protocols

### Smart Contract Security
- Comprehensive unit and integration testing
- External security audits
- Upgradeable contract patterns with governance
- Emergency pause mechanisms

## 📊 Monitoring and Analytics

### Dashboard Features
- Real-time city resilience score
- Infrastructure health visualization
- Risk level heat maps
- Response coordination status
- Recovery progress tracking

### Reporting
- Automated compliance reports
- Performance analytics
- Trend analysis and predictions
- Stakeholder communications

## 🤝 Integration Points

### External Systems
- **IoT Sensors**: Real-time infrastructure monitoring
- **Weather Services**: Environmental risk data
- **Emergency Services**: Response coordination
- **Government Systems**: Regulatory compliance
- **Public Communication**: Citizen alerts and updates

### APIs
- RESTful API for web applications
- GraphQL endpoint for complex queries
- WebSocket connections for real-time updates
- Mobile SDK for emergency apps

## 🧪 Testing

### Run Tests
```bash
# Unit tests
npx hardhat test

# Integration tests
npm run test:integration

# Coverage report
npm run coverage

# Gas optimization tests
npm run test:gas
```

### Test Networks
- **Local**: Hardhat Network
- **Testnet**: Goerli/Sepolia
- **Staging**: Private test network

## 📈 Deployment

### Environment Setup
1. **Development**: Local Hardhat network
2. **Staging**: Testnet deployment
3. **Production**: Mainnet deployment with governance

### Upgrade Process
1. Deploy new contract versions
2. Governance proposal for upgrade
3. Community voting period
4. Execution of approved upgrades
5. Migration of existing data

## 🔧 Maintenance

### Regular Tasks
- Contract upgrades and patches
- Performance optimization
- Data archiving and cleanup
- Security audit reviews
- Stakeholder training updates

### Monitoring
- Contract execution metrics
- Gas usage optimization
- Network performance tracking
- User adoption analytics

## 📚 Documentation

- [Architecture Documentation](./docs/architecture.md)
- [API Reference](./docs/api.md)
- [Deployment Guide](./docs/deployment.md)
- [User Manual](./docs/user-guide.md)
- [Developer Guide](./docs/development.md)

## 🤝 Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details on:

- Code standards and style guide
- Pull request process
- Issue reporting
- Security vulnerability disclosure
- Community guidelines

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- **Technical Issues**: [GitHub Issues](https://github.com/your-org/smart-city-resilience/issues)
- **Documentation**: [Wiki](https://github.com/your-org/smart-city-resilience/wiki)
- **Community**: [Discord Server](https://discord.gg/your-server)
- **Email**: support@smartcityresilience.org

## 🙏 Acknowledgments

- City planning departments for requirements and feedback
- Emergency services for operational insights
- Blockchain security auditors
- Open source community contributors
- Research institutions for resilience frameworks

---

**Built with ❤️ for safer, more resilient cities**
