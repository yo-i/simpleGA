//
//  main.swift
//  GAPJ
//
//  Created by yo on 2018/04/12.
//  Copyright © 2018年 yifanyang. All rights reserved.
//

import Foundation

typealias ega = [Int]
let sample:Int = 4
let gens:Int = 25

func createInitialData()->[ega]
{
    var list:[ega] = []
    for _ in 0..<sample
    {
        var subList:ega = []
        for _ in 0..<gens
        {
            subList.append(Int(arc4random() % 2))
        }
        list.append(subList)
    }
    return list
}

func isConverged(_ list:ega)->Bool
{
    if list.count == list.filter({$0 == 1}).count
    {
        print("good gen")
        return true
    }
    else
    {
        return false
    }
}

func isAllConverged(_ list:[ega])->Bool
{
    for l in list
    {
        if isConverged(l) { return true}
    }
    return false
    
}


func score(_ list:ega)->Int
{
    return list.filter({$0 == 1}).count
}


func run()
{
    let initData = createInitialData()
    print("////////////init")
    printList(initData)

    
    var age = 1

    var newData = initData
    while 1 == 1
    {
        print("age ////////   " + age.description)
        let top = IEnumerableSelect(newData)
        let crossTop = IEnumerableCross(a: top.0, b: top.1)
        
        
        print("top ----   " )
        printList([top.0,top.1])
        print("cross ----   " )
        printList([crossTop.0,crossTop.1])
        
        
        newData = Array(arrayLiteral: top.0,top.1,crossTop.0,crossTop.1)
     
        for (index,_) in newData.enumerated()
        {
            if arc4random() % 100 < 5
            {
                IEnumerableMutate(e:&newData[index])
                print("mutate !----   " )
                printList([newData[index]])

            }
        }
        
        print("new ----   " )
        printList(newData)
        if isAllConverged(newData)
        {
            
            break
        }
        
        age += 1
        
        sleep(1)
        print("")
    }
    
    
    
}

func IEnumerableMutate( e:inout ega)
{
    let point = Int(arc4random() % UInt32(gens))
    if e[point] == 0
    {
        e[point] = 1
    }
    else
    {
        e[point] = 0
    }
    
    
}

func IEnumerableSelect(_ allList:[ega])->(ega,ega)
{
    let resultList = allList.sorted(by: { score($0) > score($1) })
    
    let top1 = Array(resultList[0])
    let top2 = Array(resultList[1])
    
    return (top1,top2)
}

func IEnumerableCross(a:ega,b:ega)->(ega,ega)
{
    let point = Int(arc4random() % UInt32(gens))
    
    let a1 = Array( a.prefix(upTo: point))
    let a2 = Array( a.suffix(from: point))
    
    let b1 = Array( b.prefix(upTo: point))
    let b2 = Array( b.suffix(from: point))
    
    let newa = a1 + b2
    let newb = a2 + b1
    
    return (newa,newb)
}

func printList(_ allList:[ega])
{
    for ls in allList
    {
        print(ls.description + "  scorc: " + score(ls).description)
    }
    
}


run()

