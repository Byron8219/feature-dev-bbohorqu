@TestChapter @Byron_Bohorquez
Feature: Pruebas API Marvel Characters

  Background:
    * configure ssl = true


Scenario: Obtener todos los personajes
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bbohorqu/api/characters'
    When method get
    Then status 200
    And match response == []

Scenario: Obtener personaje por ID exitoso
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bbohorqu/api/characters/1'
    When method get
    Then status 200
    And match response == { id: 1, name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }

Scenario: Obtener personaje por ID no existe
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bbohorqu/api/characters/999'
    When method get
    Then status 404
    And match response == { error: 'Character not found' }

Scenario: Crear personaje exitoso
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bbohorqu/api/characters'
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    And header Content-Type = 'application/json'
    When method post
    Then status 201
    And match response contains { name: 'Iron Man', alterego: 'Tony Stark' }

Scenario: Crear personaje con nombre duplicado
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bbohorqu/api/characters'
    And request { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response == { error: 'Character name already exists' }

Scenario: Crear personaje con campos requeridos faltantes
    Given url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/bbohorqu/api/characters'
    And request { name: '', alterego: '', description: '', powers: [] }
    And header Content-Type = 'application/json'
    When method post
    Then status 400
    And match response == { name: 'Name is required', alterego: 'Alterego is required', description: 'Description is required', powers: 'Powers are required' }
