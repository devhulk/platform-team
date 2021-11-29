const { exec } = require('child_process');

let searchString = "team-a"
let searchResult = []

let getResourceGroups = () => {
    let promise = new Promise((resolve, reject) => {
        let cmd = 'az group list -o json'
        exec(cmd, (error, stdout, stderr) => {
        if (error) {
            reject(`exec error: ${error}`);
            return;
        }
        let rgs = JSON.parse(stdout)
        rgs.forEach((rg) => {
            let name = rg.name
            if (name.includes(searchString)) {
                searchResult.push(name)
            } 
        })
        resolve(searchResult)
        });

    })

    return promise
}

getResourceGroups()

let deleteResources = (teamName) => {
    let promise = new Promise((resolve, reject) => {
        let cmd = `az group delete --name ${teamName} -y`
        exec(cmd, (error, stdout, stderr) => {
        if (error) {
            reject(`exec error: ${error}`);
            return;
        }
        resolve(stdout)

        });

    })

    return promise

}

let main = () => {
    getResourceGroups()
    .then(() => {
        let res = searchResult
        res.forEach((teamName) => {
            console.log(teamName)
        //    deleteResources(teamName) 
        //    .then((res) => {
        //        console.log(res)
        //    })
        //    .catch(err => console.error(err))
        })
    })
    .catch(err => console.error(err))
}

main()

