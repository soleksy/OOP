package pl.mypackage

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class myApplication

fun main(args: Array<String>) {
    runApplication<myApplication>(*args)
}
