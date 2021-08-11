import logo from './logo.svg';
import './App.css';
import {askForPermissionToReceiveNotifications} from "./firebase";

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
        <button onClick={askForPermissionToReceiveNotifications}>Ask for permission</button>
      </header>
    </div>
  );
}

export default App;
