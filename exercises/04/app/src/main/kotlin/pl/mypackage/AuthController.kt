package pl.mypackage

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*


@RestController
class AuthController
@Autowired constructor(
    private val authService: AuthService
)
{


//    @Autowired
//    private lateinit var authService: AuthService // Injection with lateinit not recommended, only in rare cases.

    @PostMapping("/login", produces = [MediaType.TEXT_PLAIN_VALUE])
    fun login(@RequestBody loginForm: LoginForm): ResponseEntity<String> {
        return if ( this.authService.login(loginForm.login, loginForm.password) ){
            ResponseEntity("Success!", HttpStatus.OK)
        }else
            ResponseEntity("Auth error", HttpStatus.UNAUTHORIZED)
    }

    @GetMapping("/logout")
    fun logout(): ResponseEntity<String> {
        return ResponseEntity("Success!", HttpStatus.OK)
    }


}