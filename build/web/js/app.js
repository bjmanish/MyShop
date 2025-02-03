/* global fetch */

var config = {
    cUrl: ' https://api.countrystatecity.in/v1/countries',
    cKey: 'ZHRqSnV3MUNxZWExYmRjbWM4cjdERVFOQW9TTDMxU0hzU2RpNkw2NA=='
};

    let countrySelect = document.querySelector('.country');
    let stateSelect = document.querySelector('.state');
    let citySelect = document.querySelector('.city');

function loadCountries(){
    let apiEndPoint = config.cUrl ;

    fetch(apiEndPoint, {headers:{"X-CSCAPI-KEY":config.cKey}})
    .then(Response => Response.json())
    .then( data => {
        console.log(data);
        data.forEach(country => {
            const option = document.createElement('option');
            option.value = country.iso2;
            option.textContent = country.name;
            countrySelect.appendChild(option);
        });
    })
    .catch(error => console.log('error loading countries:', error));
}



function loadStates(){
    const selectedCountryCode = countrySelect.value;
    stateSelect.innerHTML = '<option value="">Please Select State</option>'; //for clearing existing states

    fetch(`${config.cUrl}/${selectedCountryCode}/states`, {headers:{"X-CSCAPI-KEY": config.cKey}})
    .then(Response => Response.json())
    .then(data => {
        console.log(data);
        data.forEach(state => {
            const option = document.createElement('option');
            option.value = state.iso2;
            option.textContent = state.name;
            stateSelect.appendChild(option);
        });
    })
    .catch(error => console.log('error loading states', error));
}


function loadCities(){
    const selectedCountryCode = countrySelect.value;
    const selectedStateCode = stateSelect.value;
    console.log(selectedCountryCode,selectedStateCode);
    citySelect.innerHTML = '<option value=""> Please Select City</option>'; //clear Existing cities option

    fetch(`${config.cUrl}/${selectedCountryCode}/states/${selectedStateCode}/cities`, {headers:{"X-CSCAPI-KEY":config.cKey}})
    .then(Response => Response.json())
    .then(data => {
        data.forEach(city => {
            const option = document.createElement('option');
            option.value = city.iso2;
            option.textContent = city.name;
            citySelect.appendChild(option);
        });
    })
    .catch(error => console.log('error loading cities', error));
}
 window.onload = loadCountries;
 
 
// $(function () {
//    $('#datetimepicker').datetimepicker();
//});
