import { Navbar, Welcome, Footer, Transactions } from "./components";
import Staking from "./components/Staking";

const App = () => (
  <div className="min-h-screen">
    <div className="gradient-bg-welcome">
      <Navbar />
      <Welcome />
    </div>
    {/* <Services /> */}
    <Staking />
    <Transactions />
    <Footer />
  </div>
);

export default App;
