// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>ButtonPrimary</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import SiteBanner from 'brave-ui/features/rewards/siteBanner'

class BraveRewardsPageForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {title: 'YOUR TITLE'};
    console.log("New title:" + this.state.title);
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({title: event.target.value});
  }

  handleSubmit(event) {
    alert('A name was submitted: ' + this.state.title);
    event.preventDefault();
  }

  getTitle () {
    return this.state.title;
  }

  render() {
    return (
      <div>
        <div id="site_banner">
          <SiteBanner
            bgImage={"https://www.popsci.com/sites/popsci.com/files/styles/655_1x_/public/images/2017/07/mars-surface.jpg?itok=wZc9vU-e&fc=50,50"}
            logo={"https://pbs.twimg.com/profile_images/920841899992236032/mSDhBoC9_400x400.jpg"}
            title={"Alexis Ren"}
            currentDonation={"5"}
            donationAmounts={[
              {
                "tokens": 1,
                "converted": 0.3,
                "selected": false
              },
              {
                "tokens": 5,
                "converted": 1.5,
                "selected": false
              },
              {
                "tokens": 10,
                "converted": 3,
                "selected": false
              }
            ]}
          >Hello World<br/>I wonder if this works</SiteBanner>
        </div>
        <div id="controller_form">
          <h4>PREVIEW</h4>
          <form onSubmit={this.handleSubmit}>
            <label>
              Title:
              <input type="title" value={this.state.value} onChange={this.handleChange} />
            </label>
            <input type="submit" value="Submit"/>
          </form>
        </div>
      </div>
    );
  }
}

const braveRewardsPageForm = <BraveRewardsPageForm />;

var newDiv = document.createElement('div');

/*
ReactDOM.render(
  <SiteBanner 
    bgImage={"https://www.popsci.com/sites/popsci.com/files/styles/655_1x_/public/images/2017/07/mars-surface.jpg?itok=wZc9vU-e&fc=50,50"}
    logo={"https://pbs.twimg.com/profile_images/920841899992236032/mSDhBoC9_400x400.jpg"}
    title={"Alexis Ren"}
    currentDonation={"5"}
    donationAmounts={[
      {
        "tokens": 1,
        "converted": 0.3,
        "selected": false
      },
      {
        "tokens": 5,
        "converted": 1.5,
        "selected": false
      },
      {
        "tokens": 10,
        "converted": 3,
        "selected": false
      }
    ]}
  >Hello World<br/>I wonder if this works</SiteBanner>,
  document.body.appendChild(newDiv),
)
*/

var newContent = document.createElement("div")
newDiv.appendChild(document.createElement("div"));

ReactDOM.render(
  braveRewardsPageForm,
  document.body.appendChild(newDiv)
//  newDiv.children[0].appendChild(document.createElement("div"))
)
