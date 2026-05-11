'use client'

import { useState } from 'react'
import './page.css'

type Screen =
  | 'welcome'
  | 'register1'
  | 'register2'
  | 'register3'
  | 'register4'
  | 'login'
  | 'explore'
  | 'group-detail'
  | 'create-group'
  | 'group-chat'
  | 'my-groups'
  | 'profile'
  | 'edit-profile'

export default function Preview() {
  const [screen, setScreen] = useState<Screen>('welcome')
  const [firstName, setFirstName] = useState('')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [city, setCity] = useState('')

  const reset = () => {
    setFirstName('')
    setEmail('')
    setPassword('')
    setCity('')
    setScreen('welcome')
  }

  return (
    <div className="preview-container">
      <div className="device-frame">
        <div className="device-notch"></div>
        <div className="screen">
          {screen === 'welcome' && (
            <Welcome onNext={() => setScreen('register1')} onLogin={() => setScreen('login')} />
          )}

          {screen === 'register1' && (
            <RegisterStep1
              firstName={firstName}
              setFirstName={setFirstName}
              onNext={() => setScreen('register2')}
              onBack={() => setScreen('welcome')}
            />
          )}

          {screen === 'register2' && (
            <RegisterStep2
              email={email}
              setEmail={setEmail}
              password={password}
              setPassword={setPassword}
              onNext={() => setScreen('register3')}
              onBack={() => setScreen('register1')}
            />
          )}

          {screen === 'register3' && (
            <RegisterStep3
              city={city}
              setCity={setCity}
              onNext={() => setScreen('explore')}
              onBack={() => setScreen('register2')}
            />
          )}

          {screen === 'login' && (
            <Login onSuccess={() => setScreen('explore')} onBack={() => setScreen('welcome')} />
          )}

          {screen === 'explore' && (
            <Explore
              onGroupClick={() => setScreen('group-detail')}
              onCreateClick={() => setScreen('create-group')}
              onMyGroupsClick={() => setScreen('my-groups')}
              onProfileClick={() => setScreen('profile')}
              onLogout={reset}
            />
          )}

          {screen === 'group-detail' && (
            <GroupDetail
              onBack={() => setScreen('explore')}
              onChatClick={() => setScreen('group-chat')}
            />
          )}

          {screen === 'create-group' && (
            <CreateGroup onBack={() => setScreen('explore')} onCreate={() => setScreen('explore')} />
          )}

          {screen === 'group-chat' && (
            <GroupChat onBack={() => setScreen('group-detail')} />
          )}

          {screen === 'my-groups' && (
            <MyGroups
              onGroupClick={() => setScreen('group-detail')}
              onBack={() => setScreen('explore')}
            />
          )}

          {screen === 'profile' && (
            <Profile
              firstName={firstName}
              city={city}
              onEditClick={() => setScreen('edit-profile')}
              onBack={() => setScreen('explore')}
              onLogout={reset}
            />
          )}

          {screen === 'edit-profile' && (
            <EditProfile onBack={() => setScreen('profile')} />
          )}
        </div>
        <div className="device-home"></div>
      </div>

      <div className="info-panel">
        <h1>Community App Preview</h1>
        <p className="tagline">Close the app. Open your world.</p>

        <div className="info-section">
          <h2>About</h2>
          <p>
            A countercultural app that brings people back to genuine human connection.
            No feeds, no likes, no engagement tricks—just real people meeting in real places.
          </p>
        </div>

        <div className="info-section">
          <h2>Current Screen</h2>
          <p className="current-screen">{screen.replace('-', ' ').toUpperCase()}</p>
        </div>

        <div className="info-section">
          <h2>Controls</h2>
          <p>Tap buttons in the app to navigate through screens and explore the flow.</p>
          <button className="reset-btn" onClick={reset}>
            Reset to Welcome
          </button>
        </div>

        <div className="info-section">
          <h2>Key Features</h2>
          <ul>
            <li>Onboarding flow (name, email, city)</li>
            <li>Group discovery with map/list view</li>
            <li>Create and join groups</li>
            <li>Group chat & messaging</li>
            <li>Profile management</li>
            <li>Warm, minimalist design</li>
          </ul>
        </div>

        <div className="info-section">
          <h2>Design Values</h2>
          <ul>
            <li>People over profit</li>
            <li>Safety and trust first</li>
            <li>Minimal screen time</li>
            <li>No engagement tricks</li>
            <li>Real connection focused</li>
          </ul>
        </div>
      </div>
    </div>
  )
}

function Welcome({ onNext, onLogin }: { onNext: () => void; onLogin: () => void }) {
  return (
    <div className="screen-content welcome">
      <div className="welcome-header">
        <h1>Close the app.</h1>
        <h1>Open your world.</h1>
      </div>

      <p className="welcome-description">
        A countercultural app that brings people back to genuine human connection.
        No feeds, no likes, no engagement tricks—just real people meeting in real places.
      </p>

      <div className="button-group">
        <button className="btn btn-primary" onClick={onNext}>
          Join the movement
        </button>
        <button className="btn btn-secondary" onClick={onLogin}>
          I already have an account
        </button>
      </div>
    </div>
  )
}

function RegisterStep1({
  firstName,
  setFirstName,
  onNext,
  onBack,
}: {
  firstName: string
  setFirstName: (v: string) => void
  onNext: () => void
  onBack: () => void
}) {
  return (
    <div className="screen-content register">
      <div className="back-button" onClick={onBack}>← Back</div>

      <div className="register-header">
        <h1>What's your first name?</h1>
        <p>We only ask for first names. Real people, no profiles.</p>
      </div>

      <input
        type="text"
        placeholder="First name"
        value={firstName}
        onChange={(e) => setFirstName(e.target.value)}
        className="input"
      />

      <button
        className="btn btn-primary"
        onClick={onNext}
        disabled={!firstName.trim()}
      >
        Next
      </button>
    </div>
  )
}

function RegisterStep2({
  email,
  setEmail,
  password,
  setPassword,
  onNext,
  onBack,
}: {
  email: string
  setEmail: (v: string) => void
  password: string
  setPassword: (v: string) => void
  onNext: () => void
  onBack: () => void
}) {
  return (
    <div className="screen-content register">
      <div className="back-button" onClick={onBack}>← Back</div>

      <div className="register-header">
        <h1>Create your account</h1>
        <p>Email and password to stay secure</p>
      </div>

      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        className="input"
      />

      <input
        type="password"
        placeholder="Password (8+ characters)"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        className="input"
      />

      <button
        className="btn btn-primary"
        onClick={onNext}
        disabled={!email.trim() || password.length < 8}
      >
        Next
      </button>
    </div>
  )
}

function RegisterStep3({
  city,
  setCity,
  onNext,
  onBack,
}: {
  city: string
  setCity: (v: string) => void
  onNext: () => void
  onBack: () => void
}) {
  return (
    <div className="screen-content register">
      <div className="back-button" onClick={onBack}>← Back</div>

      <div className="register-header">
        <h1>What city are you in?</h1>
        <p>We use this to find groups near you</p>
      </div>

      <input
        type="text"
        placeholder="City name"
        value={city}
        onChange={(e) => setCity(e.target.value)}
        className="input"
      />

      <button
        className="btn btn-primary"
        onClick={onNext}
        disabled={!city.trim()}
      >
        Next
      </button>
    </div>
  )
}

function Login({ onSuccess, onBack }: { onSuccess: () => void; onBack: () => void }) {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  return (
    <div className="screen-content register">
      <div className="back-button" onClick={onBack}>← Back</div>

      <div className="register-header">
        <h1>Welcome back</h1>
        <p>Sign in to your account</p>
      </div>

      <input
        type="email"
        placeholder="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        className="input"
      />

      <input
        type="password"
        placeholder="Password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        className="input"
      />

      <button
        className="btn btn-primary"
        onClick={onSuccess}
        disabled={!email.trim() || !password.trim()}
      >
        Sign In
      </button>
    </div>
  )
}

function Explore({
  onGroupClick,
  onCreateClick,
  onMyGroupsClick,
  onProfileClick,
  onLogout,
}: {
  onGroupClick: () => void
  onCreateClick: () => void
  onMyGroupsClick: () => void
  onProfileClick: () => void
  onLogout: () => void
}) {
  return (
    <div className="screen-content explore">
      <div className="screen-header">
        <h1>Find Groups</h1>
      </div>

      <div className="group-card" onClick={onGroupClick}>
        <div className="group-card-header">
          <div>
            <h3>Downtown Coffee Crew</h3>
            <p className="group-members">5/8 members</p>
          </div>
          <div className="group-time">
            <p>Thursday</p>
            <p>6:00 PM</p>
          </div>
        </div>
        <p className="group-location">Corvus Coffee</p>
        <p className="group-distance">~2.3 mi away</p>
      </div>

      <div className="group-card" onClick={onGroupClick}>
        <div className="group-card-header">
          <div>
            <h3>South End Book Club</h3>
            <p className="group-members">3/6 members</p>
          </div>
          <div className="group-time">
            <p>Tuesday</p>
            <p>7:00 PM</p>
          </div>
        </div>
        <p className="group-location">The Source Bookstore</p>
        <p className="group-distance">~1.1 mi away</p>
      </div>

      <div className="spacer"></div>

      <div className="floating-button" onClick={onCreateClick}>
        + Start a Group
      </div>

      <div className="tab-bar">
        <button className="tab-btn active">
          <span>🗺️</span> Explore
        </button>
        <button className="tab-btn" onClick={onMyGroupsClick}>
          <span>👥</span> My Groups
        </button>
        <button className="tab-btn" onClick={onProfileClick}>
          <span>👤</span> Profile
        </button>
        <button className="tab-btn logout" onClick={onLogout}>
          <span>🚪</span> Exit
        </button>
      </div>
    </div>
  )
}

function GroupDetail({ onBack, onChatClick }: { onBack: () => void; onChatClick: () => void }) {
  return (
    <div className="screen-content group-detail">
      <div className="back-button" onClick={onBack}>← Back</div>

      <h1>Downtown Coffee Crew</h1>
      <p className="group-description">
        Weekly morning coffee and real conversation
      </p>

      <div className="info-box">
        <div className="info-row">
          <span className="label">Meeting</span>
          <span className="value">Thursday at 6:00 PM</span>
        </div>
        <div className="info-row">
          <span className="label">Members</span>
          <span className="value">5/8</span>
        </div>
      </div>

      <div className="location-box">
        <p className="location-name">Corvus Coffee</p>
        <p className="location-address">123 Main St, Denver</p>
      </div>

      <div className="members-section">
        <h3>Members</h3>
        <div className="members-grid">
          {['Sarah', 'Mike', 'Jessica', 'Alex', 'Jordan'].map((name) => (
            <div key={name} className="member-avatar">
              <div className="avatar"></div>
              <p>{name}</p>
            </div>
          ))}
        </div>
      </div>

      <button className="btn btn-primary" onClick={onChatClick}>
        Join & View Chat
      </button>
    </div>
  )
}

function CreateGroup({ onBack, onCreate }: { onBack: () => void; onCreate: () => void }) {
  const [name, setName] = useState('')

  return (
    <div className="screen-content register">
      <div className="back-button" onClick={onBack}>← Back</div>

      <h1>Create a Group</h1>

      <div className="form-group">
        <label>Group Name</label>
        <input type="text" placeholder="e.g., Downtown Coffee Crew" className="input" />
      </div>

      <div className="form-group">
        <label>Description</label>
        <textarea placeholder="What's this group about?" className="input"></textarea>
      </div>

      <div className="form-group">
        <label>Meeting Day</label>
        <select className="input">
          <option>Monday</option>
          <option selected>Thursday</option>
          <option>Friday</option>
        </select>
      </div>

      <div className="form-group">
        <label>Meeting Time</label>
        <input type="time" className="input" />
      </div>

      <div className="form-group">
        <label>Location</label>
        <input type="text" placeholder="e.g., Corvus Coffee" className="input" />
      </div>

      <button className="btn btn-primary" onClick={onCreate}>
        Create Group
      </button>
    </div>
  )
}

function GroupChat({ onBack }: { onBack: () => void }) {
  const [message, setMessage] = useState('')

  return (
    <div className="screen-content chat">
      <div className="back-button" onClick={onBack}>← Back</div>

      <div className="chat-header">
        <p className="chat-tip">Keep it short. Save the real talk for in-person.</p>
      </div>

      <div className="chat-messages">
        <div className="message">
          <div className="avatar-small"></div>
          <div className="message-content">
            <p className="message-name">Sarah</p>
            <p className="message-text">Looking forward to Thursday!</p>
            <p className="message-time">2m ago</p>
          </div>
        </div>

        <div className="message">
          <div className="avatar-small"></div>
          <div className="message-content">
            <p className="message-name">Mike</p>
            <p className="message-text">Should we try the new pastries?</p>
            <p className="message-time">1m ago</p>
          </div>
        </div>
      </div>

      <div className="chat-input-box">
        <input
          type="text"
          placeholder="Message"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          className="chat-input"
        />
        <button disabled={!message.trim()}>✈️</button>
      </div>
    </div>
  )
}

function MyGroups({ onGroupClick, onBack }: { onGroupClick: () => void; onBack: () => void }) {
  return (
    <div className="screen-content explore">
      <div className="back-button" onClick={onBack}>← Back</div>
      <div className="screen-header">
        <h1>My Groups</h1>
      </div>

      <div className="group-card" onClick={onGroupClick}>
        <div className="group-card-header">
          <div>
            <h3>Downtown Coffee Crew</h3>
            <p className="group-members">5/8 members</p>
          </div>
          <div className="group-time">
            <p>Thursday</p>
            <p>6:00 PM</p>
          </div>
        </div>
        <p className="group-location">Corvus Coffee</p>
      </div>

      <div className="tab-bar">
        <button className="tab-btn" onClick={onBack}>
          <span>🗺️</span> Explore
        </button>
        <button className="tab-btn active">
          <span>👥</span> My Groups
        </button>
        <button className="tab-btn">
          <span>👤</span> Profile
        </button>
      </div>
    </div>
  )
}

function Profile({
  firstName,
  city,
  onEditClick,
  onBack,
  onLogout,
}: {
  firstName: string
  city: string
  onEditClick: () => void
  onBack: () => void
  onLogout: () => void
}) {
  return (
    <div className="screen-content profile">
      <div className="back-button" onClick={onBack}>← Back</div>

      <div className="profile-header">
        <div className="profile-avatar"></div>
        <h1>{firstName || 'User'}</h1>
        <p>{city || 'Your City'}</p>
      </div>

      <div className="profile-section">
        <div className="profile-item">
          <span>Verification Status</span>
          <span className="pending">● Pending</span>
        </div>
      </div>

      <button className="btn btn-secondary" onClick={onEditClick}>
        Edit Profile
      </button>

      <button className="btn btn-danger" onClick={onLogout}>
        Sign Out
      </button>

      <div className="tab-bar">
        <button className="tab-btn" onClick={onBack}>
          <span>🗺️</span> Explore
        </button>
        <button className="tab-btn">
          <span>👥</span> My Groups
        </button>
        <button className="tab-btn active">
          <span>👤</span> Profile
        </button>
      </div>
    </div>
  )
}

function EditProfile({ onBack }: { onBack: () => void }) {
  return (
    <div className="screen-content register">
      <div className="back-button" onClick={onBack}>← Back</div>

      <h1>Edit Profile</h1>

      <div className="form-group">
        <label>First Name</label>
        <input type="text" className="input" disabled />
      </div>

      <div className="form-group">
        <label>City</label>
        <input type="text" className="input" disabled />
      </div>

      <div className="form-group">
        <label>Neighborhood (optional)</label>
        <input type="text" placeholder="e.g., Downtown" className="input" />
      </div>

      <button className="btn btn-primary" onClick={onBack}>
        Save Changes
      </button>
    </div>
  )
}
