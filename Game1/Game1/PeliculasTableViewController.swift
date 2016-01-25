//
//  Top3TableViewController.swift
//  Game1
//
//  Created by sanxlop on 17/12/15.
//  Copyright © 2015 UPM. All rights reserved.
//

import UIKit

class PeliculasTableViewController: UITableViewController {
    
    //let URL_JSON = "http://api.myapifilms.com/imdb/idIMDB?title=lol&token=7f507478-7094-4f59-abc0-764d2da95c4c"
    let URL_JSON = "http://api.myapifilms.com/imdb/top?end=20&token=7f507478-7094-4f59-abc0-764d2da95c4c&format=json&data=0"
    
    //let URL_JSON = "http://www.myapifilms.com/imdb/top"
    
    var datos: [[String:AnyObject]] = []
    var cache: [String:UIImage] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJSON() //descargamos el JSON al cargar la App
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        cache = [:] //vaciamos el cache si hay problemas
    }

    // MARK: - Acciones
    
    private func downloadJSON() {
        
        print("Llamada a la funcion downloadJSON")
        if let url = NSURL(string: URL_JSON){
            print("url --> NSURL")
            if let data = NSData(contentsOfURL: url) {
                print("Contenido NSURL Extraido")
                if let arr = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? [String:AnyObject] {
                    print(arr)
                        if let dic = arr["data"] as? [String:AnyObject]{
                            if let dic2 = dic["movies"] as? [[String:AnyObject]]{
                                //print(dic2)
                                self.datos = dic2
                            }
                        }
                    
                }
            }
        }

    }
    
    private func downloadImages(str:String, forIndexPath ip:NSIndexPath) {
        //print("Llamada a la funcion downloadImages")
        if let url = NSURL(string: str),
           let data = NSData (contentsOfURL: url),
           let img = UIImage(data: data) {
            //print("IMG descargada")
            dispatch_async(dispatch_get_main_queue()){
                self.cache[str] = img //guardamos la imagen en cache
                if let cell = self.tableView.cellForRowAtIndexPath(ip){
                    //print("IMG agregada")
                    cell.imageView?.image = img
                }
            }
        }
        
        
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell Peli", forIndexPath: indexPath)
        
        let dic = datos //guardamos en dic el diccionario
        
        cell.textLabel?.text = dic[indexPath.row]["title"] as? String // ponemos el valor de name del dic en label
        //cell.detailTextLabel?.text = dic["year"] as? String // ponemos el valor de name del dic en label
        
        if let urlImg = dic[indexPath.row]["urlPoster"] as? String {
            if let img = cache[urlImg]{ //comprobamos si tenemos la imagen
                cell.imageView?.image = img
                print("imagen de cache")
            } else { //si no ponemos relojito, y las descargamos
                cell.imageView?.image = UIImage(named: "reloj") // ponemos una imagen por defecto por si falla
                downloadImages(datos[indexPath.row]["urlPoster"]! as! String, forIndexPath: indexPath)
            }
        }


        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
