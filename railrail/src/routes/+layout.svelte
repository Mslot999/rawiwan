<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rail Rail</title>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet">
  </head>
  <style> 
    body {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Open Sans, sans-serif;
    background-color: #CCC5B9;
  }
  
  .container {
    max-width: 95vw;
    margin: 0 auto;
    
  }
  
  nav {
    background-color: #252422;
    
  }
  
  .nav-con {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 60px;
  }
  
  .nav-links {
    display: flex;
    
  
  }
  
  .nav-links li {
    list-style: none;
    margin-left: 1.5rem;
    
  }
  
  .nav-con a {
    color: #FFFCF2;
    text-decoration: none;
    transition: color 0.3s;
  
    
  }
  
  .logo a {
    font-size: 1.5rem;
    font-weight: bolder;
  }
  /* .menu button:hover {
    background-color: #FFFCF2;
    color: #EB5E28;
  
  } */
  .nav-link {
    color: #FFFCF2;
  }
  
  .nav-link:hover {
    color: #EB5E28;
  }
  .nav-link[aria-current="page"] {
    color: #EB5E28;
    
  }
    
  </style>
  <body>
    <header>
      <nav>
        <div class="container">
          <div class="nav-con">
            <div class="logo">
              <a href="/">Rail Rail</a>
            </div>
            <ul role="menubar" class="nav-links">
              <li role="none">
                <a href="/search" role="menuitem" aria-current="page" class="nav-link btn">Order Ticket</a>
              </li>
              <li role="none">
                <a href="/history" role="menuitem" class="nav-link btn">History</a>
              </li>
            </ul>
          </div>
        </div>
      </nav>
      
    </header>
    <script>
      document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', function() {
          document.querySelectorAll('.nav-link').forEach(otherLink => {
            if (otherLink !== link) {
              otherLink.removeAttribute('aria-current');
              otherLink.style.color = '#FFFCF2';
            }
          });
          link.setAttribute('aria-current', 'page');
          link.style.color = '#EB5E28';
        });
      });
    </script>
  </body>
  
  <slot />
  