// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>ButtonPrimary</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import SiteBanner from 'brave-ui/features/rewards/siteBanner'
import { initLocale } from 'brave-ui'
import locale from 'locale/en'

class BraveRewardsPageForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {title: 'YOUR TITLE', description: 'A brief description'};
    this.handleTitleChange = this.handleTitleChange.bind(this);
    this.handleDescriptionChange = this.handleDescriptionChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleTitleChange(event) {
    this.setState({title: event.target.value});
  }

  handleDescriptionChange(event) {
    this.setState({description: event.target.value});
  }

  handleSubmit(event) {
    alert('A name was submitted: ' + this.state.title);
    event.preventDefault();
  }

  render() {
    const shrunkHeight = {
      height: '50vh'
    };

    initLocale(locale);

    return (
      <div>
        <div id="site_banner" style={shrunkHeight}>
          <SiteBanner
            bgImage={"https://www.popsci.com/sites/popsci.com/files/styles/655_1x_/public/images/2017/07/mars-surface.jpg?itok=wZc9vU-e&fc=50,50"}
            logo={"https://pbs.twimg.com/profile_images/920841899992236032/mSDhBoC9_400x400.jpg"}
            title={this.state.title}
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
          >{this.state.description}</SiteBanner>
        </div>
        <div id="controller_form">
          <hr/>
          <h4>PREVIEW</h4>
          <form onSubmit={this.handleSubmit}>
            <label>
              Title:
              <input type="title" value={this.state.value} onChange={this.handleTitleChange} />
            </label>
            <div>
              Description:
              <label>
                <textarea type="description" value={this.state.description} onChange={this.handleDescriptionChange} />
              </label>
            </div>
            <input type="submit" value="Submit"/>
          </form>
        </div>
      </div>
    );
  }
}

const braveRewardsPageForm = <BraveRewardsPageForm />;

ReactDOM.render(
  braveRewardsPageForm,
  document.body.appendChild(document.createElement("div"))
)

document.getElementById('site_banner').children[0].style.height = '50vh';
